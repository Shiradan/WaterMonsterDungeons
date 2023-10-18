extends Node

func calculate_mean(data):
	var sum = 0.0
	var count = data

	for i in range(1, data + 1):
		sum += float(i)

	if count > 0:
		return sum / float(count)
	else:
		return 0.0
