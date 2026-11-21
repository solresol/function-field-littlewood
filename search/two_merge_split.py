"""Fourth repeated (1,1) merge on both actual N=4 rays."""
from functools import reduce
from math import gcd

from search.fraction_free_block import pullback, seed, step
from search.run_rank_experiments import oracle
from search.terminal_boundary_relation import basis, null
from search.terminal_prime_obstruction import formal_series


def split_line(form, parity):
    """Signed maximal minors after restricting the boundary to h*tau."""
    pulled = pullback(form, 4, 0, parity)
    minors = [pulled.get(15 << 8, 0)]
    for i in range(4):
        other_columns = (15 ^ (1 << i)) << 8
        minor = sum(pulled.get(other_columns | (1 << j), 0) for j in range(4, 8))
        minors.append((-1)**(i + 1) * minor)
    return minors


def direct_line(initial, parity, p):
    """Solve a full child window from the root sum, projecting to (h,w)."""
    size = 72 - parity
    start = 8 * (initial + 1) + parity
    coefficients = [oracle('lai_sprang', p, start + k) * pow(2, -1, p) % p
                    for k in range(2 * size - 1)]

    def residue(child, j):
        # Unknowns (h,w): lower half h-w, upper half w.
        return [int(j < 2)] + [
            (1 if j >= 2 else -1) * int(col == 2 * child + j % 2)
            for col in range(4)]

    alpha = (1, 0, -1, 0)
    rows = []
    for i in range(size):
        coupling = [sum(alpha[(i + j) % 4] * residue(1 - parity, j)[col]
                        for j in range(4)) for col in range(5)]
        rows.append(coefficients[i:i + size] + coupling)
    for j in range(4):
        rows.append([int(k % 4 == j) for k in range(size)] +
                    [-x for x in residue(parity, j)])
    return basis([v[size:] for v in null(rows, size + 5, p)], p)


def main():
    obstructions = []
    for initial, expected_gap in ((62, 16), (126, 7632)):
        state = seed(4, initial, 8, formal_series(4, initial + 18))
        phase = initial % 4
        for _ in range(3):
            state, phase = step(state, 4, phase)
        assert phase == 3
        lines = [split_line(state[k], a) for a, k in enumerate((3, 4))]
        for p in (5, 53):
            for a, line in enumerate(lines):
                assert basis([line], p) == direct_line(initial, a, p)
        if initial == 126:
            assert all(line[0] % 53 == 0 and line[1] % 53 != 0 for line in lines)
        left, right = lines
        gap = reduce(gcd, (left[0] * y - right[0] * x
                           for x, y in zip(left[1:], right[1:])), 0)
        assert gap == expected_gap
        print(initial, 'gap gcd', gap, 'lines mod 53',
              [[x % 53 for x in line] for line in lines])
        obstructions.append(left[0] * right[0] * gap)
    assert gcd(*obstructions) == 8704


if __name__ == '__main__':
    main()
