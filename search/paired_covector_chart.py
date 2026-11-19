"""Verify the two-child chart certificate for the first phase-3 merge."""
from math import gcd

from search.fraction_free_block import pullback, seed, step
from search.lai_sprang_sharpness import normalized
from search.terminal_prime_obstruction import formal_series, rational_determinant


def direct_internal_determinant(q, parity, size):
    """Zero parent boundary, unknowns (child polynomial, four split variables)."""
    def split(child, residue, column):
        if column != 2 * child + residue % 2:
            return 0
        return -1 if residue < 2 else 1

    alpha = (1, 0, -1, 0)
    rows = []
    for i in range(size):
        hankel = [normalized(4, q + 1 + parity + i + j) for j in range(size)]
        coupling = [sum(alpha[(i + j) % 4] * split(1 - parity, j, col)
                        for j in range(4)) for col in range(4)]
        rows.append(hankel + coupling)
    for i in range(4):
        rows.append([int(j % 4 == i) for j in range(size)] +
                    [-split(parity, i, col) for col in range(4)])
    return rational_determinant(rows)


def main():
    products = []
    for initial in (62, 126):
        state = seed(4, initial, 8, formal_series(4, initial + 18))
        phase = initial % 4
        for _ in range(2):
            state, phase = step(state, 4, phase)
        assert phase == 3
        q = 4 * (initial + 1) - 1
        product = 1
        for parity, component, size in ((0, 3, 36), (1, 4, 35)):
            form = pullback(state[component], 4, 0, parity)
            determinant = form.get(0b1111 << 8, 0)
            assert determinant == direct_internal_determinant(q, parity, size)
            print(initial, parity, determinant)
            product *= determinant
        products.append(product)
    assert gcd(*products) == 32
    print('gcd of ray products = 32')


if __name__ == '__main__':
    main()
