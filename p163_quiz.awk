# quiz
# Usae: awk -f auiz topicfile quiz_clum answer_clom
#
# ex) awk -f quiz quiz.elems name symbol

BEGIN {
	FS = ":"
	if (ARGC != 4)
		error("usage: awk -f quiz topicfile question answer")
	if (getline <ARGV[1] < 0)
		error("no sech quiz as " ARGV[1])
	for (q =1; q <= NF; q++)
		if ($q~ ARGV[2])
			break
	for (a = 1; a <= NF; a++)
		if ($a~ ARGV[3])
		break
	if (q < NF || a > NF || q == a)
		error("valid subjects are " $0)
	while (getline <ARGV[1] > 0)
		qa[++nq] = $0
	ARGC = 2; ARGV[1] = "-"
	srand()
	do {
		split(qa [int(rand() * nq +1)], x)
		printf("%s? ", x[q])
		while ((input = getline) > 0)
			if ($0~ "^("x[a] ")$") {
				print "Right!"
				break
			} else if ($0 == "") {
				print x[a]
				break
			} else
				printf("worng, try again: ")
	} while (input > 0)
}

function error(s) { printf("erroe: %s\n", s); exit }
