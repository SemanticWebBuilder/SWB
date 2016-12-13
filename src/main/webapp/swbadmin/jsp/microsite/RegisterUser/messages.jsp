<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.User"%>
<%
    String msg=request.getParameter("msg");
    if(msg!=null)
    {
        if(msg.equals("ok")){
            %>
 <pre>
    <b>Gracias por registrarse en este portal, se le ha enviado un correo electrónico para que usted
    confirme su registro.
    </b>
 </pre>
            <%
        }
    }else if(request.getAttribute("2confirm")!=null){
        SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
        WebSite website=paramRequest.getWebPage().getWebSite();
        User user=(User)request.getAttribute("user");
        %>
            <pre>
                <b>
                Hola <%=user.getFullName()%>,<br/>
                te damos la más cordial bienvenida a este sitio y te informamos<br/>
                que haz quedado registrado en el portal de <%=website.getDisplayTitle(user.getLanguage())%>.<br/><br/>
                Es importante que te firmes en el portal con tu clave y password que nos 
                proporcionaste e ingreses a la página de tu perfil a actualizar tus datos.
                </b>
            </pre>
            <meta http-equiv="refresh" content="5;url=<%=website.getHomePage().getUrl()%>" />

        <%
    }
   
%>
