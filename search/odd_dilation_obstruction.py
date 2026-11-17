"""Exact controls for the characteristic-two odd-dilation obstruction.

Ordinary all-scale proof: results/2026-11-18-odd-dilation-obstruction.md.
These are prescribed identity controls, not a search or an infinite proof.
The independent series checker divides the logarithmic-derivative rational
seed before summing its dilates; it does not use the unit-part formula.
"""
import json
from math import isqrt
from time import perf_counter


def parameters(ell, r):
    if (ell < 3 or ell % 2 == 0 or
            any(ell % d == 0 for d in range(2, isqrt(ell)+1)) or r < 1):
        raise ValueError('require an odd prime ell and r>=1')
    return ell**r


def coefficient(ell, r, n):
    N = parameters(ell, r)
    if n < 1:
        raise ValueError('coefficient indices start at one')
    while n % ell == 0:
        n //= ell
    return int(n % N == 1 and n % (ell*N) != 1)


def rational_series(ell, r, endpoint):
    """Expand x*y*Phi_N'(y)/Phi_N(y), y=x^ell, then sum dilates.

    All arrays are inclusive through endpoint; XOR is exact F_2 arithmetic.
    Phi_N(y)=sum_(h=0)^(ell-1) y^(h*N/ell).
    """
    N = parameters(ell, r)
    denominator = [h*N for h in range(1, ell)]
    numerator = {1+h*N for h in range(1, ell, 2)}
    seed = [0]*(endpoint+1)
    for n in range(endpoint+1):
        seed[n] = int(n in numerator)
        for d in denominator:
            if d <= n:
                seed[n] ^= seed[n-d]
    out, scale = [0]*(endpoint+1), 1
    while scale <= endpoint:
        for n in range(1, endpoint//scale+1):
            out[n*scale] ^= seed[n]
        scale *= ell
    return out


def root_oracle(ell, N, modulus, endpoint):
    """Direct primitive-root sums in small, explicitly checked binary fields.

    Polynomial-basis elements are bit masks; no unit-part or rational-series
    formula is used. The caller supplies the fixed irreducible modulus.
    """
    size = 1 << (modulus.bit_length()-1)

    def mul(a, b):
        out = 0
        while b:
            if b & 1:
                out ^= a
            b >>= 1
            a <<= 1
            if a & size:
                a ^= modulus
        return out

    def power(a, n):
        out = 1
        while n:
            if n & 1:
                out = mul(out, a)
            a = mul(a, a)
            n >>= 1
        return out

    # Exhaustive inverses independently check that the chosen quotient is a field.
    assert all(any(mul(a, b) == 1 for b in range(1, size))
               for a in range(1, size))
    roots = [z for z in range(1, size)
             if power(z, N) == 1 and power(z, N//ell) != 1]
    assert len(roots) == N-N//ell
    sums = []
    for h in range(N):
        total = 0
        for z in roots:
            total ^= power(z, h)
        assert total in (0, 1)
        sums.append(total)
    out = [0]*(endpoint+1)
    scale = 1
    while scale <= endpoint:
        for h in range((endpoint//scale-1)//ell+1):
            out[scale*(ell*h+1)] ^= sums[h % N]
        scale *= ell
    return out


def run():
    started, records = perf_counter(), []
    # Fixed controls motivated by the proof, no prime or witness search.
    for ell, r in ((3, 1), (3, 2), (5, 1), (5, 2), (7, 1)):
        N = parameters(ell, r)
        endpoint = (ell*N+1)*ell**3
        independent = rational_series(ell, r, endpoint)
        assert all(coefficient(ell, r, n) == independent[n]
                   for n in range(1, endpoint+1))
        for a in range(4):
            L = ell**a
            m, d, j = L, N*L, (ell-1)*N*L
            values = [independent[m+h] ^ independent[m+d+h]
                      for h in range(1, j+1)]
            assert not any(values[:-1]) and values[-1] == 1
            # Every row of the dilation identity through the first hit.
            for h in range(1, j+1):
                expected = (independent[1+h//L] ^ independent[N+1+h//L]
                            if h % L == 0 else 0)
                assert values[h-1] == expected
            records.append(dict(ell=ell, r=r, a=a, m=m, degree=d,
                                first_index=j, defect=j-d,
                                sparse_multiplier_exponents=[0, d],
                                endpoint_inclusive=m+d+j))
    root_controls = []
    for ell, r, modulus in ((3, 1, 0b111), (3, 2, 0b1000011),
                            (5, 1, 0b10011), (7, 1, 0b1011)):
        endpoint = (ell**(r+1)+1)*ell**2
        roots = root_oracle(ell, ell**r, modulus, endpoint)
        assert roots == rational_series(ell, r, endpoint)
        root_controls.append(dict(ell=ell, r=r, modulus=modulus,
                                  endpoint_inclusive=endpoint))
    return dict(classification='ordinary mathematical obstruction; finite controls only',
                records=records, direct_root_controls=root_controls,
                dependencies='Python standard library', seed=None,
                seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
