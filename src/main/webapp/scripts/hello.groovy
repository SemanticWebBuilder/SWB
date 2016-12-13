import org.semanticwb.model.User
if (!session) {
  session = request.getSession(true)
}

if (!session.counter) {
      session.counter = 1
}

def params = request.getAttribute("paramRequest");
User user = (User)params.getUser();
html.html {    // html is implicitly bound to new MarkupBuilder(out)
  head {
      title("Groovy Servlet")
  }
  body {
    p("Hello, ${request.remoteHost}: ${session.counter}! ${new Date()} ${user.getLogin()} ")
  }
}
session.counter = session.counter + 1