<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>


<%!
    private int getExistingCommunities(WebPage wp, User user)
    {
        int numc = 0;
        Iterator<WebPage> itwp = wp.listChilds(user.getLanguage(), Boolean.TRUE, Boolean.FALSE, Boolean.FALSE, Boolean.TRUE);
        while (itwp.hasNext())
        {
            WebPage wpit = itwp.next();
            if (wpit instanceof MicroSite)
            {
                numc++;
            }
        }
        return numc;
    }
%>

<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage webPage = paramRequest.getWebPage();

            WebPage wpch = null;
            WebPage wpgs = null;

            int nwp = 0;
            int nms = 0;

            Iterator<WebPage> itso = webPage.listChilds(user.getLanguage(), true, false, false, true);
            if (itso.hasNext())
            {
                while (itso.hasNext())
                {
                    WebPage so = itso.next();
                    if (so instanceof WebPage && !(so instanceof MicroSite))
                    {
                        nwp++;
                        //break;
                    }
                    else
                    {
                        nms++;
                    }
                }
            }

            int numcomm = 0;
            int nums = 0;
            String nummsg = "";
            int wplevel = webPage.getLevel();

            Iterator<WebPage> itwp = webPage.listChilds(user.getLanguage(), Boolean.TRUE, Boolean.FALSE, Boolean.FALSE, Boolean.TRUE);

            if (wplevel == 3 || nwp == 0)
            {
                if (nms > 0)
                {
%>
<ul id="MenuBar3" class="MenuBarHorizontal" style="margin-top:10px">
    <li class="selectTitle">
        <p>Comunidades relacionadas</p>
        <ul>
            <%
                    if (itwp.hasNext())
                    {
                        while (itwp.hasNext())
                        {
                            wpch = itwp.next();
                            if (wpch.isActive() && !wpch.isDeleted())
                            {
            %>
            <li><a href="<%=wpch.getUrl()%>"><%=wpch.getDisplayTitle(user.getLanguage())%></a></li>
            <%
                            }
                        }
                    }
                    else
                    {
            %>
            <li>No hay comunidades relacionadas</li>
            <%            }
            %>
        </ul>
    </li>
</ul>
<script type="text/javascript">
    <!--
    var MenuBar2 = new Spry.Widget.MenuBar("MenuBar3");
    //-->
</script>
<%
                }
            }
            else if (wplevel == 2)
            {
                wpch = paramRequest.getWebPage();
%>
<div class="groupInteres">
    <h3 class="titulo"><a href="<%=wpch.getUrl()%>"><%=wpch.getDisplayTitle(user.getLanguage())%></a></h3>
    <%

                Iterator<WebPage> itwpch = wpch.listChilds(user.getLanguage(), Boolean.TRUE, Boolean.FALSE, Boolean.FALSE, Boolean.TRUE);
                if (itwpch.hasNext())
                {
    %>
    <ul>
        <%
        while (itwpch.hasNext())
        {
            wpgs = itwpch.next();

            if (!(wpgs instanceof MicroSite) && wpgs.isActive() && !wpgs.isDeleted() && !(wpgs instanceof MicroSiteWebPageUtil))
            {
                numcomm = getExistingCommunities(wpgs, user);
                nummsg = "";
                if (numcomm > 0)
                {
                    nummsg = "(" + numcomm + ")";
                }
        %>
        <li><a href="<%=wpgs.getUrl()%>"><%=wpgs.getDisplayTitle(user.getLanguage())%>&nbsp;<%=nummsg%></a></li>
        <%
            }
            numcomm = 0;

        }
        %>
    </ul>
    <%
                }
    %>
</div>
<%
            }
            else if (wplevel == 1)
            {
                while (itwp.hasNext())
                {

                    wpch = itwp.next();

                    if (wpch.isActive() && !wpch.isDeleted())
                    {
                        nums++;
%>
<div class="groupInteres">
    <h3 class="titulo"><a href="<%=wpch.getUrl()%>"><%=wpch.getDisplayTitle(user.getLanguage())%></a></h3>
    <%
                        Iterator<WebPage> itwpch = wpch.listChilds(user.getLanguage(), Boolean.TRUE, Boolean.FALSE, Boolean.FALSE, Boolean.TRUE);
                        if (itwpch.hasNext())
                        {
    %>
    <ul>
        <%
                    while (itwpch.hasNext())
                    {
                        wpgs = itwpch.next();

                        if (!(wpgs instanceof MicroSite) && wpgs.isActive() && !wpgs.isDeleted() && !(wpgs instanceof MicroSiteWebPageUtil))
                        {
                            numcomm = getExistingCommunities(wpgs, user);
                            nummsg = "";
                            if (numcomm > 0)
                            {
                                nummsg = "(" + numcomm + ")";
                            }
        %>
        <li><a href="<%=wpgs.getUrl()%>"><%=wpgs.getDisplayTitle(user.getLanguage())%>&nbsp;<%=nummsg%></a></li>
        <%
                        }
                        numcomm = 0;

                    }
        %>
    </ul>
    <%
                        }
    %>
</div>
<%
                    }
                }
            }
%>
