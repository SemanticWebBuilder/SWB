<%-- 
    Document   : view
    Created on : 30/08/2009, 11:38:59 AM
    Author     : juan.fernandez
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%!
    private Member getMember(User user, MicroSite site)
    {
        //System.out.println("getMember:"+user+" "+site);
        if(site!=null)
        {
            Iterator<Member> it=Member.ClassMgr.listMemberByUser(user,site.getWebSite());
            while(it.hasNext())
            {
                Member mem=it.next();
                //System.out.println("mem:"+mem+" "+mem.getMicroSite());
                if(mem.getMicroSite().equals(site))
                {
                   return mem;
                }
            }
        }
        return null;
    }
%>






<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    User user=paramRequest.getUser();
    WebPage wp = paramRequest.getWebPage();
    WebSite model = wp.getWebSite();

    Member member = null;

    boolean isMicrosite = false;

    if (wp instanceof MicroSite) {
        isMicrosite = true;
        member = getMember(user, (MicroSite)wp);
    }

    if (isMicrosite&&member!=null&&member.getAccessLevel()>=Member.LEVEL_ADMIN&&user.isRegistered()) {
        if (paramRequest.getCallMethod() == SWBParamRequest.Call_STRATEGY) {
            SWBResourceURL url = paramRequest.getRenderUrl();
            url.setParameter("act", "edit");
            url.setCallMethod(SWBResourceURL.Call_CONTENT);
            url.setWindowState(SWBResourceURL.WinState_MAXIMIZED);
%>
<li><a href="<%=url%>">Administrar Comunidad</a></li>
<%
            out.println("");
            
        }
   }
%>