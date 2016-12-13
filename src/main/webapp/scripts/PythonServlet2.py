import sys,calendar,time

from java.io import *

from javax.servlet.http import HttpServlet

class PythonServlet2 (HttpServlet):
	def doGet(self,request,response):
		self.doPost (request,response)

	def doPost(self,request,response):
		toClient = response.getWriter()
		response.setContentType ("text/html")
		toClient.println ("<html><head><title>Servlet Test 3</title>")
		toClient.println ("<body><h1>Calendar</h1><pre>%s</pre></body></html>" %
						  calendar.calendar(time.localtime()[0]))

