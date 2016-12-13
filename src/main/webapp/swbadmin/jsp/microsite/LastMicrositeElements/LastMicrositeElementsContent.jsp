<%@page import="java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            String webpath = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/LastMicrositeElements/";
            String defaultFormat = "dd/MM/yyyy HH:mm";
            SimpleDateFormat iso8601dateFormat = new SimpleDateFormat(defaultFormat);
            ArrayList<MicroSiteElement> elements = (ArrayList<MicroSiteElement>) request.getAttribute("elements");
            if (elements.size() > 0)
            {

                for (MicroSiteElement element : elements)
                {
                    User user = paramRequest.getUser();
                    boolean canview = false;
                    if (element.getWebPage() != null && user != null)
                    {
                        Member member = Member.getMember(user, element.getWebPage());
                        if (member != null)
                        {
                            canview = element.canView(member);
                        }
                    }
                    String title = element.getTitle();
                    String description = element.getDescription();
                    String created = "Sin fecha";
                    String updated = created;
                    if (element.getCreated() != null)
                    {
                        created = iso8601dateFormat.format(element.getCreated());
                    }
                     if (element.getUpdated() != null)
                    {
                        updated = iso8601dateFormat.format(element.getUpdated());
                    }
                    if (description == null)
                    {
                        description = "Sin descripción";
                    }
                    if (description.length() > 150)
                    {
                        description = description.substring(0, 97) + " ...";
                    }
                    String url = element.getURL();
                    String src = "blog.jpg";
                    if (element instanceof PostElement)
                    {
                        src = "blog.jpg";
                    }
                    else if (element instanceof VideoElement)
                    {
                        src = "video.jpg";
                    }
                    else if (element instanceof ProductElement)
                    {
                        src = "producto.jpg";
                    }
                    else if (element instanceof PhotoElement)
                    {
                        src = "foto.jpg";
                    }
                    else if (element instanceof EventElement)
                    {
                        src = "eventos.jpg";
                    }
                    src = webpath + src;
%>
<div class="profilePic" onMouseOver="this.className='profilePicHover'" onMouseOut="this.className='profilePic'">
    

    <%
                    if (canview)
                    {
    %>
    <a class="contactos_nombre" href="<%=url%>"><img src="<%=src%>" width="60" height="60" alt="" /></a>
    <p>&nbsp;</p>
    <p>
        <a class="contactos_nombre" href="<%=url%>"><%=title%></a>
    </p>
    <%
                    }
                    else
                    {
                        %>
                        <img src="<%=src%>" width="60" height="60" alt="" />
                        <p>&nbsp;</p>
                        <%=title%>
                        <%
                    }
    %>
    <p>&nbsp;</p>
    <p><%=description%></p>
    <p>&nbsp;</p>
    <p>Creado: <%=created%></p>
    <%
        if(!updated.equalsIgnoreCase(created))
            {
            %>
            <p>Actualizado: <%=updated%></p>
            <%
            }
    %>
</div>
<%
                }
            }
            else
            {
%>
<p>No hay blogs, videos, fotos, etc, publicados en el sitio</p>
<%            }
%>



