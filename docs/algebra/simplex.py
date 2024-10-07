"""simplest possible simplex implementation"""
import numpy as np

def main():
    A = np.array([[-2, 1, 1, 0, 0], [-1, 2, 0, 1, 0], [1, 0, 0, 0, 1]])
    b = np.array([2, 7, 3])
    c = np.array([-1, -2, 0, 0, 0])
    x = simplex(A, b, c)
    return x

def simplex(A, b, c):
    """revised simplex method. """
    m, n, o = A.shape[0], A.shape[1], A.shape[1] - A.shape[0]
    ns, v1, v2 = [i for i in range(n)], np.array(c[o:]), np.array(c[:o])
    Binv = np.linalg.inv(A[:, ns[o:]])
    while not np.min(v2 - v1 @ Binv @ A[:, ns[:o]]) > 0:
        n1 = np.argmin(v2 - v1 @ Binv @ A[:, ns[:o]])
        t1, t2 = Binv @ b, Binv @ A[:, ns[n1]]
        n2 = np.argmin([t1[i] / t2[i] if t2[i] > 0 else np.inf for i in range(m)])
        ns[n1], ns[n2 + o], v1[n2], v2[n1] = ns[n2 + o], ns[n1], v2[n1], v1[n2]
        Binv = np.linalg.inv(A[:, ns[o:]])
    return Binv @ b

if __name__ == "__main__":
    main()
