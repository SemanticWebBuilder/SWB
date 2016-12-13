<%@page import="java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            ArrayList<MicroSiteElement> elements = (ArrayList<MicroSiteElement>) request.getAttribute("elements");
            if (paramRequest.getCallMethod() == paramRequest.Call_CONTENT)
            {
%>
<jsp:include flush="true" page="LastMicrositeElementsContent.jsp"></jsp:include>
<%            }
            else
            {
%>
<h2>Actividad m&aacute;s reciente en el sitio</h2>
<ul class="listaElementos">
    <%
                if (elements.size() == 0)
                {
    %>
    <li>No hay actividad durante las últimas dos semanas</li>
    <%                }
                User user = paramRequest.getUser();
                for (MicroSiteElement element : elements)
                {
                    boolean canview = false;
                    if (element.getWebPage() != null && user != null)
                    {
                        Member member = Member.getMember(user, element.getWebPage());
                        if (member != null)
                        {
                            canview = element.canView(member);
                        }
                    }
                    String created = "Sin fecha";
                    if (element.getCreated() != null)
                    {
                        created = SWBUtils.TEXT.getTimeAgo(element.getCreated(), "es");
                    }
                    String title = element.getTitle();
                    String textcreated = "creó el elemento ";
                    if (element instanceof NewsElement)
                    {
                        textcreated = "creó la noticia ";
                    }
                    if (element instanceof PostElement)
                    {
                        textcreated = "creó la entrada ";
                    }
                    if (element instanceof VideoElement)
                    {
                        textcreated = "subió el video ";
                    }
                    if (element instanceof PhotoElement)
                    {
                        textcreated = "subió la imagen ";
                    }
                    if (element instanceof EventElement)
                    {
                        textcreated = "registró el evento ";
                    }

                    String postAuthor = "Usuario dado de baja";
                    if (element.getCreator() != null)
                    {
                        postAuthor = element.getCreator().getFirstName();
                    }
    %>
    <li><%=postAuthor%>  <%=textcreated%>
        <%
                    if (canview)
                    {
        %>
        <a href="<%=element.getURL()%>">
            <%=title%>
        </a>
        <%
        }
        else
        {
        %>
        <%=title%>
        <%
                    }
        %>

						, <%=created%></li>
        <%            }
        %>
</ul>
<%
            }
%>

