import csv
import random
import math
import operator
import matplotlib.pyplot as plt
import numpy as np

def normalise(set_data):
	
	for x in range(len(set_data)):
	    for y in xrange(1,14):
	        set_data[x][y] = float(set_data[x][y])
	elements = len(set_data)
	features = len(set_data[0])
	max_stor = []
	for i in xrange(1,features):
		maxe = 0 
		for j in xrange(0,elements):
			if set_data[j][i] > maxe:
				maxe = set_data[j][i]
		max_stor.append(maxe)
	for i in xrange(0,elements):
		for j in xrange(1,features):
			set_data[i][j] /= max_stor[j-1]


def loadDataset(count,fold_elements, dataset, trainingSet=[] , testSet=[]):
	
	for x in range(len(dataset)):
	    for y in range(1,14):
	        dataset[x][y] = float(dataset[x][y])
	#token = int(len(dataset)*split) 
	for i in xrange(count,count + fold_elements):
		testSet.append(dataset[i])	
	for i in xrange(0,len(dataset)):
		if i not in xrange(count,count + fold_elements):
			trainingSet.append(dataset[i])
	

def getResponse(neighbors):
	classVotes = {}
	invd = {}
	for x in range(len(neighbors)):
		response = neighbors[x][0][0]
		inv = neighbors[x][1]
		if response in classVotes:
			classVotes[response] += 1
			invd[response] += inv
		else:
			classVotes[response] = 1
			invd[response] = inv
	sortedVotes = sorted(classVotes.iteritems(), key=operator.itemgetter(1), reverse=True)
	DisVotes = sorted(invd.iteritems(), key=operator.itemgetter(1), reverse=True)
	#print sortedVotes
	if len(sortedVotes) == 1 or sortedVotes[0][1] > sortedVotes[1][1]:
		return sortedVotes[0][0]
	else :
		#print DisVotes
		#print sortedVotes
		return DisVotes[0][0]

def getNeighbors(trainingSet, testInstance, k):
	distances = []
	length = len(testInstance)

	for x in xrange(0,len(trainingSet)):
		#print testInstance
		dist = manhattanDistance(testInstance, trainingSet[x], length)
		if dist > 0.0 :
			distances.append((trainingSet[x], dist, 1/dist))
		else : 
			distances.append((trainingSet[x], dist, 100000))
	distances.sort(key=operator.itemgetter(1))
	neighbors = []
	for x in range(k):
		neighbors.append((distances[x][0],distances[x][2]))
	return neighbors

def euclideanDistance(instance1, instance2, length):
	distance = 0
	for x in xrange(1,length):
		#print x
		distance += pow((instance1[x] - instance2[x]), 2)

	return math.sqrt(distance)

def manhattanDistance(instance1, instance2, length):
	distance = 0
	for x in range(1,length):
		#print x
		distance += abs(instance1[x] - instance2[x])

	return distance

def getAccuracy(testSet, predictions):
	correct = 0
	for x in range(len(testSet)):
		if testSet[x][0] == predictions[x]:
			correct += 1
	return (correct/float(len(testSet))) * 100.0

def plot(karray, mean_of_chunks, stdev, axs, kfold):
	ax = axs[kfold/4, (kfold%2)]
	#	plt.figure()
	ax.errorbar(karray, mean_of_chunks	, yerr=stdev, fmt = 'o')
	ax.set_title('Plot for '+str(kfold)+' fold')
	ax.set_xlabel('k')
	ax.set_ylabel('Mean Accuracy')

if __name__ == '__main__':
	trainingSet = []
	testSet = []
	dilim = 0.50
	filename = 'wine.data'
	with open(filename, 'rb') as csvfile:
	    rows = csv.reader(csvfile)
	    #print rows
	    dataset = list(rows)
	    dataset = [ x for x in dataset if len(x) > 0]
	    for i in xrange(0,5):
	    	random.shuffle(dataset)
	#dataset has been set
	#print dataset
	normalise(dataset)
	total_elements = len(dataset)
	fig, axs = plt.subplots(nrows=2, ncols=2, sharex=True)

	for fold in xrange(2,6):
		
		
		#mean = [0,0,0,0,0,0]
		for k in xrange(1,6):
			fold_elements = total_elements/fold
			count =0
			accuracy = []
			mean_of_chunks = []
			stdev = []
			for index in xrange(0,fold):
				trainingSet = []
				testSet = []
				loadDataset(count,fold_elements, dataset, trainingSet, testSet)
				#print count , fold_elements
				count += fold_elements
				#print len(testSet) , len(trainingSet)
				predictions=[]
				#k = 3
			
				#for k in xrange(1,6):

				for x in range(len(testSet)):
					neighbors = getNeighbors(trainingSet, testSet[x], k)
					#print neighbors
					result = getResponse(neighbors)
					#print result
					predictions.append(result)
				accuracy.append(getAccuracy(testSet, predictions))
				#mean[k] += accuracy
			#print accuracy/fold  , fold , k
			print accuracy
			print np.mean(accuracy)
			print np.std(accuracy)
			mean_of_chunks.append(np.mean(accuracy))
			stdev.append(np.std(accuracy))
			plot(k, mean_of_chunks, stdev, axs, fold)
	plt.show()	