<%@page import="java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.resources.sem.BookmarkEntry, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
            if(request.getParameter("user")!=null)
            {
                return;
            }
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            Iterator<BookmarkEntry> entries = (Iterator<BookmarkEntry>) request.getAttribute("entries");
            SWBResourceURL aUrl = paramRequest.getActionUrl().setAction("ADDNEW");
            //boolean showList = (Boolean) request.getAttribute("l");
            int maxBookmarks = 10;
            boolean existe = false;
            entries = (Iterator<BookmarkEntry>) request.getAttribute("entries");

            ArrayList<BookmarkEntry> arrayEntries = new ArrayList<BookmarkEntry>();
            if (entries != null && entries.hasNext())
            {
                while (entries.hasNext())
                {
                    BookmarkEntry entry = entries.next();
                    arrayEntries.add(entry);
                    if (paramRequest.getWebPage().getUrl().equalsIgnoreCase(entry.getBookmarkURL()))
                    {
                        existe = true;
                    }
                }

                entries = arrayEntries.iterator();
            }

%>
<%
            if (paramRequest.getUser().isSigned())
            {
%>
<%
    if(paramRequest.getCallMethod()==paramRequest.Call_STRATEGY)
        {
        %>
        <h2>Mis Favoritos</h2>
        <%
        }
%>
<script language="Javascript" type="text/javascript">
    function validateremove(url, title)
    {
        if(confirm('¿Esta seguro de borrar la liga a favorito: '+title+'?'))
        {            
            window.location.href=url;
        }
    }
</script>
<%
                if (arrayEntries.size() > 0)
                {
%>
<ul class="userList">
    <%


                    int bkCount = 0;
                    if (entries != null && entries.hasNext() /*&& showList*/)
                    {
    %>

    <%
                        while (entries.hasNext() && bkCount < maxBookmarks)
                        {
                            BookmarkEntry entry = entries.next();


    %>

    <li>

        <a href="<%=entry.getBookmarkURL()%>">
            <%=entry.getTitle()%>
        </a>

        <%
                            if (paramRequest.getCallMethod() == paramRequest.Call_CONTENT)
                            {
                                SWBResourceURL removeUrl = paramRequest.getActionUrl();
                                removeUrl.setAction("DELETE").setParameter("id", entry.getId());
                                String removeurl = "javascript:validateremove('" + removeUrl + "','" + entry.getTitle() + "')";
        %>

        <a class="userListLink" href="<%=removeurl%>">Eliminar <%=entry.getTitle()%></a>



        <%
                            }
        %>
    </li>
    <%
                            bkCount++;
                        }

                    }
                    if (paramRequest.getUser().isSigned())
                    {
                        if (!existe && paramRequest.getCallMethod() != paramRequest.Call_CONTENT)
                        {
    %>

    <li><a class="userListLink" href="<%=aUrl%>">Agregar esta p&aacute;gina </a></li>

    <%
                        }
                    }
    %>
</ul>
<%
                }
                else
                {
%>
<ul class="userList">
<%
                    if (paramRequest.getCallMethod() != paramRequest.Call_CONTENT)
                    {
%>
<li><a class="userListLink" href="<%=aUrl%>">Agregar esta p&aacute;gina </a></li>
<%
                    }
                    else
                    {
%>
<li>No tiene ligas registradas.</li>
    <%        }
    %>
</ul>
<%
                }
            }
%>
