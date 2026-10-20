"""Bounded root-evaluation state for Lai--Sprang Hankel parity recursion.

Ordinary proof and scope: results/2026-10-19-boundary-relation.md.
The recursive path never constructs a Hankel block larger than 1 by 1.
This checks a structural identity, not new sharpness witnesses or reachability.
Run: python3 -m search.terminal_boundary_relation
"""
from functools import lru_cache
import json
import platform
from time import perf_counter

from search.lai_sprang_sharpness import (
    cover_cases, cover_parameters, derived_window, kernel, normalized, v2,
)
from search.run_rank_experiments import oracle


def basis(rows, p):
    """Canonical reduced row basis, including the zero subspace."""
    a = [[x % p for x in row] for row in rows]
    if not a:
        return ()
    k = 0
    for j in range(len(a[0])):
        i = next((i for i in range(k, len(a)) if a[i][j]), None)
        if i is None:
            continue
        a[k], a[i] = a[i], a[k]
        z = pow(a[k][j], -1, p)
        a[k] = [x*z % p for x in a[k]]
        for i in range(len(a)):
            if i != k:
                z = a[i][j]
                a[i] = [(x-z*y) % p for x, y in zip(a[i], a[k])]
        k += 1
        if k == len(a):
            break
    return tuple(tuple(row) for row in a[:k])


def null(rows, width, p):
    return kernel(rows or [[0]*width], p)


class BoundaryRelations:
    def __init__(self, p):
        if p < 3 or any(p % q == 0 for q in range(2, int(p**0.5)+1)):
            raise ValueError('require an odd prime')
        self.p = p
        self.N = 1 << v2(p-1)
        self.H = self.N // 2
        self.roots = tuple(z for z in range(1, p) if pow(z, self.N, p) == 1)
        self.index = {z: i for i, z in enumerate(self.roots)}
        self.primitive = tuple(i for i, z in enumerate(self.roots)
                               if pow(z, self.H, p) == p-1)
        self.max_merge_variables = 0

    def direct(self, t, m, n, independent=True):
        """Relation (u,v): A x=U_m u, v=U_n^T x; also invisible nullity.

        A_ij=c_(t+i+j), U_iz=z^i. Independent readback uses original root
        sums, divided by H, and solves the whole system without recursion.
        """
        p, N, roots = self.p, self.N, self.roots
        c = (lambda k: oracle('lai_sprang', p, k)*pow(self.H, -1, p) % p
             ) if independent else lambda k: normalized(N, k) % p
        A = [[c(t+i+j) for j in range(n)] for i in range(m)]
        U = [[pow(z, i, p) for z in roots] for i in range(m)]
        V = [[pow(z, j, p) for j in range(n)] for z in roots]
        equations = [[-x for x in u]+a for u, a in zip(U, A)]
        solutions = null(equations, N+n, p)
        projected = [s[:N]+[sum(a*b for a, b in zip(row, s[N:])) % p
                            for row in V] for s in solutions]
        invisible = len(null(A+V, n, p)) if n else 0
        return basis(projected, p), invisible

    @lru_cache(None)
    def recursive(self, t, m, n):
        if t < 1 or min(m, n) < 0 or abs(m-n) > 1:
            raise ValueError('require t>=1 and nonnegative, nearly square sizes')
        if max(m, n) <= 1:
            return self.direct(t, m, n, independent=False)[0]
        children = tuple(self.recursive((t+a+(t+a) % 2)//2,
                                       (m+1-a)//2, (n+1-(t+a) % 2)//2)
                         for a in (0, 1))
        return self.merge(t, children)

    def merge(self, t, children):
        """Pure parity merge; children are ordered by ROW parity.

        Only t modulo 2N is used. Callers must supply correlated child
        relations with the appropriate sizes; arbitrary pairings are not
        certified as actual stream states.
        """
        p, N, roots = self.p, self.N, self.roots
        width = 3*N  # variables u, v_even, v_odd
        self.max_merge_variables = max(self.max_merge_variables, width)
        equations = []
        for a in (0, 1):
            b = (t+a) % 2  # column parity of the even-index (recursive) block
            other = 1-b
            child = children[a]
            # Linear map (u,v0,v1) -> (D_a u - K_k v_other, v_b).
            mapping = [[0]*width for _ in range(2*N)]
            for j, z in enumerate(roots):
                mapping[self.index[z*z % p]][j] = pow(z, a, p)
                mapping[N+j][N*(1+b)+j] = 1
            k = (t+a+other-1)//2
            for j in self.primitive:
                mapping[j][N*(1+other)+j] = -pow(roots[j], k, p)*pow(self.H, -1, p) % p
            # Membership in a subspace is annihilation by its orthogonal.
            for h in null(child, 2*N, p):
                equations.append([sum(h[i]*mapping[i][j] for i in range(2*N)) % p
                                  for j in range(width)])
        W = null(equations, width, p)
        projected = []
        for w in W:
            v = [(w[N+self.index[z*z % p]]
                  + z*w[2*N+self.index[z*z % p]]) % p for z in roots]
            projected.append(w[:N]+v)
        result = basis(projected, p)
        # The proof says internal boundary data cannot disappear on projection.
        assert len(result) == len(W), ('invisible merge kernel', t)
        return result

    def terminal(self, relation):
        target = [0]*(2*self.N)
        target[self.N+self.index[1]] = 1
        return basis(list(relation)+[target], self.p) == relation


def run():
    started = perf_counter()
    comparisons = []
    for p, limit in ((3, 8), (5, 16), (13, 12), (41, 16), (17, 8)):
        engine = BoundaryRelations(p)
        count = 0
        # Fixed small parity/rectangle checks, with zero shift included (t=1).
        for t in (1, 2, 3, 4, 7, 8, 15, 16, 31, 32):
            for n in range(limit+1):
                for m in (max(0, n-1), n, n+1):
                    recursive = engine.recursive(t, m, n)
                    direct, invisible = engine.direct(t, m, n)
                    assert recursive == direct and invisible == 0, (p, t, m, n)
                    assert len(recursive) == engine.N+n-m
                    if m == n:
                        N = engine.N
                        assert all(sum(x[i]*y[N+i]-x[N+i]*y[i] for i in range(N)) % p == 0
                                   for x in recursive for y in recursive)
                    count += 1
        comparisons.append(dict(p=p, N=engine.N, comparisons=count,
                                max_merge_variables=engine.max_merge_variables))
    covers = []
    for p, E in ((5, 8), (41, 4)):
        engine = BoundaryRelations(p)
        N = engine.N
        T, L, P, _ = cover_parameters(N, E)
        checked, skipped, hits = 0, 0, []
        for b, x in cover_cases(N, E):
            # Bounded actual representatives only. We do NOT apply the stream
            # recurrence to unrealizable abstract hole assignments.
            hole = next((i for i in range(1, T+1) if (b+i) % L == 0), None)
            M = next((b+q*P for q in range(2*N)
                      if x is None or normalized(N, b+q*P+hole) == x), None)
            if M is None:
                skipped += 1
                continue
            n = N+E  # S=F V, deg S=n-1, terminal rows exactly n
            relation = engine.recursive(M+1, n, n)
            direct, invisible = engine.direct(M+1, n, n)
            assert relation == direct and invisible == 0
            s = derived_window(N, E, b, x)
            assert all(s[k] % p == sum(normalized(N, M+k+1+i)
                                       for i in range(N)) % p for k in range(len(s)))
            terminal = bool(kernel([s[k:k+E+1] for k in range(N+E)], p))
            assert engine.terminal(relation) == terminal
            if terminal:
                hits.append(dict(b=b, x=x, M=M))
            checked += 1
        covers.append(dict(p=p, E=E, checked_actual_representatives=checked,
                           abstract_cases_without_representative=skipped,
                           representative_q_range=[0, 2*N-1], hits=hits))
    witness_engine = BoundaryRelations(5)
    assert witness_engine.terminal(witness_engine.recursive(312, 12, 12))
    assert not witness_engine.terminal(witness_engine.recursive(314, 12, 12))
    S = [2, 3, 4, 0, 1, 3, 3, 3, 1, 3, 2, 1]
    moments = [sum(s*pow(z, i, 5) for i, s in enumerate(S)) % 5
               for z in witness_engine.roots]
    assert moments == [1, 0, 0, 0]
    r1_engine = BoundaryRelations(3)
    assert r1_engine.terminal(r1_engine.recursive(2, 2, 2))
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scope='bounded identity checks, not state reachability',
                rectangle_checks=comparisons, covers=covers,
                p5_known_witness=True, shifted_negative_control=True, r1_control=True,
                primitive_only_state_failure=dict(p=5, t=312, size=12,
                    roots=list(witness_engine.roots), witness_moments=moments),
                runtime_seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
