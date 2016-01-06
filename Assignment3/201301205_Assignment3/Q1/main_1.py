import csv,random
import numpy as np

Count = {}
Count1 = {}

def readData():
	with open('bank-full.csv', 'rb') as f:
		reader = csv.reader(f)
		elems = list(reader)
		UseFeatures = []
		for row_c in xrange(1,len(elems)):
			elems[row_c][0] = elems[row_c][0].split(";")
			#print elems[row_c][0]
			temp = []
			for index in xrange(0,17):
				if(index == 0 or index == 5 or index ==9 or index == 11 or index == 12 or index == 13 or index == 14):
					continue
				#print index
				ele = elems[row_c][0][index]
				try:
					ele = int(ele)
				except Exception:
					ele = ele.replace('"','')
				temp.append(ele)
			#print temp
			UseFeatures.append(temp)
	return UseFeatures
                
def randomize(data):
	for i in xrange(10):
		random.shuffle(data)
	return data

def NBTrain(TrData):
	Count['yes'] = 0    
	Count['no'] = 0
	Count1['yes'] = {}
	Count1['no'] = {} 
	global Attr
	Attr = []
	
	for i in xrange(0,len(TrData[0])-1):
		temp = []
		for j in TrData:
			if j[i] not in temp:
				temp.append(j[i])
		Attr.append(temp)
	#print Attr
	#print len(Attr)	
	for i in TrData:
		Count[i[-1]] += 1
		for j in xrange(0,len(i)-1):
			try:
				Count1[i[-1]][i[j]] += 1
			except :
				Count1[i[-1]][i[j]] = 1
	

def AccuVerify(TsData):
	temp1 = Count['yes'] / ( Count['yes'] + Count['no'] + 0.0)
	temp2 = Count['no'] / ( Count['yes'] + Count['no'] + 0.0)
	Tot = 0
	Corr = 0.0
	for i in TsData:
		Ans1 = (temp1 + 0.0)
		for j in xrange(len(i)-1):
			Sum = 0
			for k in Attr[j]:
				try:
					Sum += Count1['yes'][k]
				except Exception:
					Sum += 0.0
			Sum += 0.0
			try:
				Sum =  (Count1['yes'][i[j]])/ Sum
			except Exception:
				Sum =0
			Ans1 = Ans1 * Sum

		Ans2 = (temp2 + 0.0)
		for j in xrange(len(i)-1):
			Sum = 0
			for k in Attr[j]:
				try:
					Sum += Count1['no'][k]
				except Exception:
					Sum += 0.0
			Sum += 0.0
			try:
				Sum =  (Count1['no'][i[j]])/ Sum
			except Exception:
				Sum =0
			Ans2 = Ans2 * Sum
		if Ans1 > Ans2:
			#print "yes"
			if ('yes' == i[-1]):
				Corr +=1

		else:
			#print "no"
			if ('no' == i[-1]):
				Corr +=1
		Tot +=1
	return Corr/Tot


if __name__ == '__main__':
	data = readData()
	
	#print len(data)
	accuracies = []	
	for i in xrange(0,10):
		data = randomize(data)
		TsData = data[0:len(data)/2]
		TrData = data[len(data)/2:len(data)]
		#print len(TsData), len(TrData)
		NBTrain(TrData)
		
		#print len(Attr)
		accuracies.append(AccuVerify(TsData))
	print accuracies
	print np.mean(accuracies)
	print np.std(accuracies)
