<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%!    private static final int COMMENTS_IN_PAGE = 5;
%>
<%

            MicroSiteElement mse = (MicroSiteElement) request.getAttribute("MicroSiteElement");
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            WebPage webPage = paramRequest.getWebPage();
            Member mem = Member.getMember(paramRequest.getUser(), webPage);
            long lpage = (Long) request.getAttribute("page");
            String perfilPath = paramRequest.getWebPage().getWebSite().getWebPage("perfil").getUrl();
            boolean isAdministrator = false;
            User user = paramRequest.getUser();
            if (user != null)
            {
                GenericIterator<UserGroup> groups = user.listUserGroups();
                while (groups.hasNext())
                {
                    UserGroup group = groups.next();
                    if (group != null && group.getId().equals("admin"))
                    {
                        isAdministrator = true;
                        break;
                    }
                }
            }
            Iterator iterator = mse.listComments();
            int ordinal = 0;
            long firstInPage = ((lpage - 1) * COMMENTS_IN_PAGE) + 1;
            long lastInPage = lpage * COMMENTS_IN_PAGE;

            iterator = SWBComparator.sortByCreated(iterator, false);

            while (iterator.hasNext())
            {
                Comment comment = (Comment) iterator.next();
                ordinal++;

                if (ordinal < firstInPage)
                {
                    continue;
                }
                else if (ordinal > lastInPage)
                {
                    break;
                }
                String spamMark = "[marcar como spam]";
%>
<div id="comment<%=comment.getId()%>" class="comment">
    <%
                try
                {
                    if (comment.getCreator() != null && comment.getCreator().getPhoto() != null)
                    {
    %>
    <script type="text/javascript">
        <!--
        document.write('<img src="<%=SWBPortal.getWebWorkPath()%><%=comment.getCreator().getPhoto()%>" alt="foto"/>');
        -->
    </script>

    <%
                    }
                    else
                    {
    %>
    <img src="<%=SWBPortal.getContextPath()%>/swbadmin/images/defaultPhoto.jpg" alt="foto"/>
    <%
                    }
                }
                catch (NullPointerException npe)
                {
                    npe.printStackTrace();
                }
                //out.write("<span class="comment-auth">");
%>
    <div class="commentText">
        <p>Escrito por
            <%
                try
                {
                    if (comment.getCreator() != null && !comment.getCreator().getFullName().equals(""))
                    {
            %>
            <a href="<%=perfilPath%>?user=<%=comment.getCreator().getEncodedURI()%>"><%=comment.getCreator().getFullName()%></a>
            <%
                    }
                    else
                    {
            %>
            Desconocido
            <%        }
                }
                catch (NullPointerException npe)
                {
            %>
            Desconocido
            <%        }
            %>
            <%=SWBUtils.TEXT.getTimeAgo(comment.getCreated(), mem.getUser().getLanguage())%>
        </p>
        <p>
            <script type="text/javascript">
                <!--
                document.write('<%=comment.getDescription()%>');
                -->
            </script>

        </p>
        <% int spam = 0;
                try
                {
                    spam = comment.getSpam();
                }
                catch (Exception e)
                {
                    comment.setSpam(0);
                    e.printStackTrace();
                }
        %>
        <div id="labeldivspamMark<%=comment.getId()%>"><p><%=spam%> marcas como spam</p></div>

        <%
                if (mem.canView() && request.getSession().getAttribute(comment.getURI()) == null)
                {

        %>
        <div id="divspamMark<%=comment.getId()%>"><p><a href="javascript:spam(<%=comment.getId()%>)" id="spamMark<%=comment.getId()%>"><%=spamMark%></a></p></div>
        <%
                }

        %>
        <%
                if (isAdministrator)
                {
        %>
        <div><p><a href="javascript:deletecomment('<%=comment.getEncodedURI()%>','<%=comment.getDescription()%>',<%=comment.getId()%>)" id="delspamMark<%=comment.getId()%>">[Eliminar]</a></p></div>
        <%
                }
        %>

    </div>
</div>

<%
            }

%>
