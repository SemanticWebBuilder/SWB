<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%!    private static final int COMMENTS_IN_PAGE = 5;
    private static final int PAGE_INDEXES_TO_SHOW = 5;

    private long totalPagesNumber(MicroSiteElement mse)
    {
        long totalPages = 1L;
        long comments = 0L;
        GenericIterator<Comment> iterator = mse.listComments();

        while (iterator.hasNext())
        {
            iterator.next();
            comments++;
        }
        if (comments > COMMENTS_IN_PAGE)
        {
            totalPages = comments / COMMENTS_IN_PAGE;
            if (comments % COMMENTS_IN_PAGE > 0)
            {
                totalPages++;
            }
        }
        return totalPages;
    }
%>
<%
            MicroSiteElement mse = (MicroSiteElement) request.getAttribute("MicroSiteElement");
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            SWBResourceURL url = paramRequest.getRenderUrl();
            String uri = (String) request.getAttribute("suri");
            long lpage = (Long) request.getAttribute("page");
            long totalPages = totalPagesNumber(mse);
            boolean hasCommensts = mse.listComments().hasNext();

%>
<div>
    <div id="commentsList">        
        <jsp:include flush="true" page="CommentsByPage.jsp" />
        <%
            if (totalPages > 0)
            {
        %>
        <div class="clearL"></div>
        <div id="commentsIndex">
            <div class="commentsIndexContainer">
                <%
                url.setCallMethod(SWBResourceURL.Call_CONTENT);
                url.setParameter("act", "detail");
                //TODO: colocar el uri codificado para que sea un parametro valido
                url.setParameter("uri", uri);
                if (lpage > 1)
                {
                %>
                <span class="commentPageLink"><a href="<%=url.toString(true)%>&amp;pn=<%=(lpage - 1)%>" title="P&aacute;gina anterior">&lt;&lt;</a></span>
                <%
                }
                long ini = 1L;
                long fin = PAGE_INDEXES_TO_SHOW;
                long dif = 0;
                if ((totalPages < PAGE_INDEXES_TO_SHOW))
                {
                    fin = totalPages;
                }
                if (totalPages > PAGE_INDEXES_TO_SHOW && lpage > 1)
                {
                    dif = lpage - 1;
                    if (totalPages >= (PAGE_INDEXES_TO_SHOW + dif))
                    {
                        fin = PAGE_INDEXES_TO_SHOW + dif;
                        ini = 1 + dif;
                    }
                    else
                    {
                        fin = totalPages;
                        ini = totalPages - PAGE_INDEXES_TO_SHOW + 1;
                    }
                }
                if (hasCommensts && totalPages > 1)
                {
                    for (long i = ini; i <= fin; i++)
                    {
                        if (i != lpage)
                        {
                %>
                <span class="commentPageLink"><a href="<%=url.toString(true)%>&amp;pn=<%=i%>"><%=String.valueOf(i)%></a></span>
                <%
                        }
                        else
                        {
                %>
                <span class="currentPage"><%=String.valueOf(i)%></span>
                <%
                        }
                    }
                    if (lpage < totalPages)
                    {
                %>
                <span class="commentPageLink"><a href="<%=url.toString(true)%>&amp;pn=<%=(lpage + 1)%>" title="P&aacute;gina siguiente">&gt;&gt;</a></span>
                <%
                    }
                }
            }
            if (!hasCommensts)
            {
                %>
                <p>No hay comentarios</p>
                <%            }
                %>
            </div>
            <br/>
        </div>
    </div>
</div>