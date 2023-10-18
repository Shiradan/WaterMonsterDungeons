extends Node

func calculate_mean(data):
	var sum: = 0.0
	var count = 0

	for value in data:
		sum += float(value)
		count += 1

	if count > 0:
		return sum / float(count)
	else:
		return 0.0
