BEGIN { FS = ":" }
      { x[NR] = $1; y[NR] = $2 }
END   { for (;;) print x[randint(NR)], y[randint(NR)] }

function randint(n) { return int(n * rand()) + 1}
