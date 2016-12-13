<%-- 
    Document   : viewDetailEvent
    Created on : 13/05/2011, 03:59:04 AM
    Author     : Martha
--%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.text.*,org.semanticwb.SWBUtils,org.semanticwb.portal.api.*,org.semanticwb.portal.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%@page import="java.util.ArrayList,org.semanticwb.portal.resources.sem.calendar.*"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%
    String id = request.getParameter("id");
    WebPage wp = paramRequest.getWebPage();
    User user = paramRequest.getUser();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sd = new SimpleDateFormat("dd/MM/yyyy");
    
    if(id != null) {
%><div class="detailEvt">
<%      Event ev = Event.ClassMgr.getEvent(id, wp.getWebSite());
        if(ev != null) {
            if(ev.getPhotoPrincipal() != null) {
%>          <div class="image"><img src="<%=SWBPortal.getWebWorkPath()+ev.getWorkPath()+"/"+ev.getPhotoPrincipal()%>"/></div>
<%          }%>
            <div class="title"><%=ev.getTitle(user.getLanguage()) == null ? ev.getTitle() : ev.getTitle(user.getLanguage())%></div>
            <%  String description = ev.getDescription(user.getLanguage()) == null ? (ev.getDescription() == null ? "" : ev.getDescription()) : ev.getDescription(user.getLanguage());
            if(description.length() > 0) { %>
            <div class="description"><%=description%></div>
<%          }
            if(ev.getEventInitDate() != null) {
                String dates="";
                Date ds1 = sdf.parse(ev.getEventInitDate());
                dates = sd.format(ds1) ;
                if(ev.getEventEndDate() != null) {
                    Date ds2 = sdf.parse(ev.getEventEndDate());
                    dates = dates + " - ";
                    dates = dates + sd.format(ds2);
                }
            %>
            <div class="dates"><%=dates%></div>
<%          }
            if(ev.getContentEvent() != null) {
%>          <div class="content"><%=ev.getContentEvent()%></div>
<%          }
        }%>
</div>
<%    }
%>