extends Node

func calculate_mean(data):
	var dataArray=[]
	var i=1
	while i<=data:
		dataArray.append(i)
		i+=1
	var sum: = 0.0
	var count = dataArray.size()

	for value in dataArray:
		sum += float(value)

	if count > 0:
		return sum / float(count)
	else:
		return 0.0
