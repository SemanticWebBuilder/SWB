from javax.servlet.http import HttpServlet

class PythonServlet (HttpServlet):
	def doGet(self,request,response):
		self.doPost (request,response)

	def doPost(self,request,response):
		toClient = response.getWriter()
		response.setContentType ("text/html")
		toClient.println ("<html><head><title>Servlet Test</title>" +
						  "<body><h1>Servlet Test</h1></body></html>")
