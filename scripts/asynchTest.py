from threading import Thread
from queue import Queue
import time

concurrent = 200
res = open("threadTestFile" , "a")


def doWork(i,res):
	res.write(str(i) + "\n")
	time.sleep(1)
	res.write(str(i) + "\n")
	print(str(i))
	print(str(i))

for i in range(1,51):
	# doWork(i)
	t = Thread(target=doWork, args=(i,res,))
	#t.daemon = True
	t.start()

print("Main thread exited!!!")
