<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>


<%!    private final int ABSTRACT_SIZE = 80;
%>

<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    ArrayList<SemanticObject> objects = (ArrayList<SemanticObject>) request.getAttribute("owners");
    ArrayList<Comment> comments = (ArrayList<Comment>) request.getAttribute("comments");

    String defaultFormat = "dd/MM/yyyy HH:mm";
    SimpleDateFormat iso8601dateFormat = new SimpleDateFormat(defaultFormat);
    String perfilPath = paramRequest.getWebPage().getWebSite().getWebPage("perfil").getUrl();
%>

<%
    if (comments.size() > 0) {%>
<h2>Opiniones m&aacute;s recientes</h2>
<ul class="listaElementos"><%
for (int i = 0; i < comments.size(); i++) {
    Comment com = comments.get(i);
String whoName = "Usuario dado de baja";
    if (com.getCreator() != null)
    {
        whoName = com.getCreator().getFirstName();
    }
    String what = trunkText(com.getDescription(), ABSTRACT_SIZE);
    String whereUrl = "#";
    String whereTitle = "";

    if (objects.get(i).instanceOf(DirectoryObject.sclass)) {
        DirectoryObject dob = (DirectoryObject)objects.get(i).createGenericInstance();
        whereUrl = dob.getWebPage().getUrl() +
                "?act=detail&uri=" + dob.getEncodedURI();
        whereTitle = dob.getTitle();
    } else if (objects.get(i).instanceOf(MicroSiteElement.sclass)) {
        MicroSiteElement mse = (MicroSiteElement)objects.get(i).createGenericInstance();
        whereUrl = mse.getWebPage().getUrl() + "?act=detail&uri=" + mse.getEncodedURI();
        whereTitle = mse.getTitle();
    }
    %>
    <li>
        <p>
            <span><b><%=whoName%></b></span>
            en <span><b><%=whereTitle%></b></span>:
        </p>
        <p>
            <%=what%>...<a href="<%=whereUrl%>"><i>(Leer m&aacute;s)</i></a>
        </p>
    </li>
    <%
}
    %></ul><%
%>

<%  }%>

<%!
    private String trunkText(String text, int nChars) {
        int end = nChars;

        if (text.length() < nChars) return text;

        if (text.charAt(end) != ' ') {
            while (text.charAt(++end) != ' ') ;
        }

        return text.substring(0, end);
    }
%>