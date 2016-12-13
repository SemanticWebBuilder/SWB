<%-- 
    Document   : addEvent
    Created on : 4/05/2011, 12:01:04 PM
    Author     : martha.jimenez
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="net.fckeditor.*" %>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.resources.sem.calendar.*,java.net.URLDecoder"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.*,java.util.*,org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.model.*,org.semanticwb.platform.*"%>
<%
    User user = paramRequest.getUser();
    Resource base = paramRequest.getResourceBase();
    SWBResource wbBase = SWBPortal.getResourceMgr().getResource(base);
    SemanticObject objn = ((GenericSemResource)wbBase).getSemanticObject();
    org.semanticwb.portal.resources.sem.calendar.Calendar cal = (org.semanticwb.portal.resources.sem.calendar.Calendar) objn.createGenericInstance();

    ArrayList roles = new ArrayList();
    String getRole1 = cal.getRoleForAdmin();
    while(getRole1 != null && getRole1.trim().length() > 1) {
        int num = getRole1.indexOf(",");
        if(num == -1 && getRole1.length() > 1) {
            roles.add(getRole1.trim());
            break;
        } else {
            String data1 = getRole1.substring(0, num);
            if(data1.trim().length() > 1) {
                roles.add(data1.trim());
            }
            num = num + 1;
            getRole1 = getRole1.substring(num ,getRole1.length());
            if(getRole1.indexOf(",") == -1) {
                if(getRole1.trim().length() > 1) {
                    roles.add(getRole1.trim());
                }
                break;
            }
        }
    }


if(user.getRole() != null && roles.contains(user.getRole().getId())) {

    SWBResourceURL url = paramRequest.getActionUrl();
    SWBResourceURL urlBack = paramRequest.getRenderUrl();
    net.fckeditor.FCKeditor fckEditor = new net.fckeditor.FCKeditor(request, "contentEvent");
    fckEditor.setToolbarSet("Basic");
    fckEditor.setHeight("450");
%>
<link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/js/fckeditor/editor/css/sample.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
	dojo.require("dojo.parser");
	dojo.addOnLoad(function(){
		dojo.parser.parse(); // or set djConfig.parseOnLoad = true
	});

        dojo.require("dijit.form.ValidationTextBox");
        dojo.require("dijit.form.DateTextBox");
        dojo.require("dijit.form.Textarea");
        dojo.require("dijit.form.FilteringSelect");
</script>
<%    if(request.getParameter("_mode") != null && request.getParameter("_mode").equals("modEdit")) {
        String uri=request.getParameter("uri");
        SemanticObject semObject = SemanticObject.createSemanticObject(URLDecoder.decode(request.getParameter("uri")));
        SWBFormMgr mgr = new SWBFormMgr(semObject, null, SWBFormMgr.MODE_EDIT);
        mgr.setLang(user.getLanguage());
        mgr.setType(mgr.TYPE_DOJO);
        mgr.setLang(user.getLanguage());
        SemanticObject sobj1 = null;
        Event evt = null;
        if(request.getParameter("uri") != null) {
            sobj1 = SemanticObject.createSemanticObject(URLDecoder.decode(request.getParameter("uri")));
            evt = (Event) sobj1.createGenericInstance();
        }
        String content = "";
        if(evt != null && evt.getContentEvent() != null) {
            content = evt.getContentEvent();
            fckEditor.setValue(content);
        }
        String checked = "";
        if(evt.isUrlInternal()) {
            checked = "checked";
        }
        String checked1 = "";
        if(evt.isNewWindow()) {
            checked1 = "checked";
        }
        if(request.getParameter("msgErr") != null) {
        %><p><%=request.getParameter("msgErr")%></p><%
        }
%>
<script type="text/javascript">
    function validateData() {
        if(document.frmEdit.<%=Event.swb_title.getName()%>.value == '') { alert('<%=paramRequest.getLocaleString("lb_required")%> <%=Event.swb_title.getDisplayName(user.getLanguage()) == null ? Event.swb_title.getDisplayName() : Event.swb_title.getDisplayName(user.getLanguage())%>'); document.frmEdit.<%=Event.swb_title.getName()%>.focus(); return false; }
        if(dijit.byId('<%=Event.cal_eventInitDate.getName()%>').value == '' || !dijit.byId('<%=Event.cal_eventInitDate.getName()%>').isValid()) { alert('<%=paramRequest.getLocaleString("lb_required")%> <%=Event.cal_eventInitDate.getDisplayName(user.getLanguage()) == null ? Event.cal_eventInitDate.getDisplayName() : Event.cal_eventInitDate.getDisplayName(user.getLanguage())%>'); dijit.byId('<%=Event.cal_eventInitDate.getName()%>').focus(); return false; }
        if(dijit.byId('<%=Event.cal_eventEndDate.getName()%>').value == '' || !dijit.byId('<%=Event.cal_eventEndDate.getName()%>').isValid()) { alert('<%=paramRequest.getLocaleString("lb_required")%> <%=Event.cal_eventEndDate.getDisplayName(user.getLanguage()) == null ? Event.cal_eventEndDate.getDisplayName() : Event.cal_eventEndDate.getDisplayName(user.getLanguage())%>'); dijit.byId('<%=Event.cal_eventEndDate.getName()%>').focus(); return false; }
        document.frmEdit.submit();
    }
</script>
<form action="<%=url.setAction(SWBResourceURL.Action_EDIT).setParameter("uri",uri)%>" method="post" name="frmEdit">
    <input type="hidden" name="scls" value="<%=Event.sclass%>"/>
    <input type="hidden" name="smode" value="create"/>
    <input type="hidden" name="sref" value="<%=semObject.getURI()%>"/>
    <fieldset>
    <%--=mgr.renderLabel(request, Event.swb_title,mgr.MODE_EDIT)--%>
    <label for="<%=Event.swb_title.getName()%>"><%=Event.swb_title.getDisplayName(user.getLanguage()) == null ? SWBUtils.XML.replaceXMLChars(Event.swb_title.getDisplayName()) : SWBUtils.XML.replaceXMLChars(Event.swb_title.getDisplayName(user.getLanguage()))%></label>
    <%--=mgr.renderElement(request, Event.swb_title,mgr.MODE_EDIT)--%>
    <input name="<%=Event.swb_title.getName()%>" size="30" value="<%= SWBUtils.XML.replaceXMLChars(evt.getTitle())%>" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="Captura Título." invalidMessage="Título es requerido."  trim="true" style="width:300px;"/>
    <%=mgr.renderLabel(request, Event.swb_description,mgr.MODE_EDIT)%>
    <textarea name="<%=Event.swb_description.getName()%>" id="<%=Event.swb_description.getName()%>" dojoType_="dijit.Editor" rows="1" style="width:300px; height: 50px"><%=SWBUtils.XML.replaceXMLChars(evt.getDescription(user.getLanguage()) == null ? (evt.getDescription() == null ? "" : evt.getDescription()) : evt.getDescription(user.getLanguage()))%></textarea>
    <%--=mgr.renderElement(request, Event.swb_description,mgr.MODE_EDIT)--%>
    <%=mgr.renderLabel(request,Event.cal_periodicity,mgr.MODE_CREATE)%>
    <%=mgr.renderElement(request,Event.cal_periodicity,mgr.MODE_CREATE)%>
    <%=mgr.renderLabel(request, Event.cal_eventInitDate,mgr.MODE_EDIT)%>
    <input id="eventInitDate" name="eventInitDate" value="<%=evt.getEventInitDate() == null ? "" : evt.getEventInitDate()%>" dojoType="dijit.form.DateTextBox" style="width: 300px;"/>
    <%--=mgr.renderElement(request, Event.cal_eventInitDate,mgr.MODE_EDIT)--%>
    <%=mgr.renderLabel(request, Event.cal_eventEndDate,mgr.MODE_EDIT)%>
    <%--=mgr.renderElement(request, Event.cal_eventEndDate,mgr.MODE_EDIT)--%>
    <input id="eventEndDate" name="eventEndDate" value="<%=evt.getEventEndDate() == null ? "" : evt.getEventEndDate()%>" dojoType="dijit.form.DateTextBox"  style="width: 300px;"/>
    <%=mgr.renderLabel(request, Event.cal_urlInternal,mgr.MODE_EDIT)%>
    <input type="checkbox" name="<%=Event.cal_urlInternal.getName()%>" <%=checked%>>
    <%--=mgr.renderElement(request, Event.cal_urlInternal,mgr.MODE_EDIT)--%>
    <%=mgr.renderLabel(request, Event.cal_urlExternal,mgr.MODE_EDIT)%>
    <%=mgr.renderElement(request, Event.cal_urlExternal,mgr.MODE_EDIT)%>
    <%=mgr.renderLabel(request, Event.cal_newWindow,mgr.MODE_EDIT)%>
    <input type="checkbox" name="<%=Event.cal_newWindow.getName()%>" <%=checked1%>>
    <%--=mgr.renderElement(request, Event.cal_target,mgr.MODE_EDIT)--%>
    <%=mgr.renderLabel(request, Event.cal_image,mgr.MODE_EDIT)%>
    <%=mgr.renderElement(request, Event.cal_image,mgr.MODE_EDIT)%>
    <%if(evt.getImage() != null) {%>
    <a href="<%=SWBPortal.getWebWorkPath()+evt.getWorkPath()+"/"+evt.getImage()%>"><%=evt.getImage()%></a>
    <%} %>
    <%=mgr.renderLabel(request, Event.cal_photoPrincipal,mgr.MODE_EDIT)%>
    <%=mgr.renderElement(request, Event.cal_photoPrincipal,mgr.MODE_EDIT)%>
    <%=mgr.renderLabel(request, Event.cal_contentEvent, mgr.MODE_EDIT)%>
    <%if(evt.getPhotoPrincipal() != null) {%>
    <a href="<%=SWBPortal.getWebWorkPath()+evt.getWorkPath()+"/"+evt.getPhotoPrincipal()%>"><%=evt.getPhotoPrincipal()%></a>
    <%} %>
    <%=fckEditor%>
    </fieldset>
    <fieldset>
        <div><label for="<%=Event.swb_creator.getName()%>"><%=Event.swb_creator.getDisplayName(user.getLanguage()) == null ? Event.swb_creator.getDisplayName() : Event.swb_creator.getDisplayName(user.getLanguage()) %></label>
        <span style="width:300px;"><%=evt.getCreator() == null ? "" : evt.getCreator().getName() %></span></div>
        <div><label for="<%=Event.swb_created.getName()%>"><%=Event.swb_created.getDisplayName(user.getLanguage()) == null ? Event.swb_created.getDisplayName() : Event.swb_created.getDisplayName(user.getLanguage()) %></label>
        <span style="width:300px;"><%=evt.getCreated() == null ? "" : evt.getCreated().toString()%></span></div>
        <div><label for="<%=Event.swb_modifiedBy.getName()%>"><%=Event.swb_modifiedBy.getDisplayName(user.getLanguage()) == null ? Event.swb_modifiedBy.getDisplayName() : Event.swb_modifiedBy.getDisplayName(user.getLanguage()) %></label>
        <span style="width:300px;"><%=evt.getModifiedBy() == null ? "" : evt.getModifiedBy().getName()%></span></div>
        <div><label for="<%=Event.swb_updated.getName()%>"><%=Event.swb_updated.getDisplayName(user.getLanguage()) == null ? Event.swb_updated.getDisplayName() : Event.swb_updated.getDisplayName(user.getLanguage()) %></label>
        <span style="width:300px;"><%=evt.getUpdated() == null ? "" : evt.getUpdated().toString()%></span></div>
    </fieldset>
    <fieldset class="buttons">
        <button type="button" class="bnt1" onclick="validateData()"><%=paramRequest.getLocaleString("lb_send")%></button>
        <button type="button" class="bnt1" onclick="document.frmCan.submit()"><%=paramRequest.getLocaleString("lb_return")%></button>
    </fieldset>
</form>
<form action="<%=urlBack.setMode("viewEvts")%>" name="frmCan" id="frmCan" method="post"></form>
<%    } else if(request.getParameter("_mode") != null && request.getParameter("_mode").equals("modAdd")) {
        SemanticObject sobj = Event.sclass.getSemanticObject();
        SemanticClass cls = Event.sclass; 
        SWBFormMgr mgr = new SWBFormMgr(cls, sobj, null);
        mgr.setLang(user.getLanguage());
        mgr.setType(mgr.TYPE_DOJO);
        mgr.setLang(user.getLanguage());

        if(request.getParameter("msgErr") != null) {
        %><p><%=request.getParameter("msgErr")%></p><%
        }
%>
<script type="text/javascript">
    function validateData() {
        if(document.frmAdd.<%=Event.swb_title.getName()%>.value == '') { alert('<%=paramRequest.getLocaleString("lb_required")%> <%=Event.swb_title.getDisplayName(user.getLanguage()) == null ? Event.swb_title.getDisplayName() : Event.swb_title.getDisplayName(user.getLanguage())%>'); document.frmAdd.<%=Event.swb_title.getName()%>.focus(); return false; }
        if(dijit.byId('<%=Event.cal_eventInitDate.getName()%>').value == '' || !dijit.byId('<%=Event.cal_eventInitDate.getName()%>').isValid()) { alert('<%=paramRequest.getLocaleString("lb_required")%> <%=Event.cal_eventInitDate.getDisplayName(user.getLanguage()) == null ? Event.cal_eventInitDate.getDisplayName() : Event.cal_eventInitDate.getDisplayName(user.getLanguage())%>'); dijit.byId('<%=Event.cal_eventInitDate.getName()%>').focus(); return false; }
        if(dijit.byId('<%=Event.cal_eventEndDate.getName()%>').value == '' || !dijit.byId('<%=Event.cal_eventEndDate.getName()%>').isValid()) { alert('<%=paramRequest.getLocaleString("lb_required")%> <%=Event.cal_eventEndDate.getDisplayName(user.getLanguage()) == null ? Event.cal_eventEndDate.getDisplayName() : Event.cal_eventEndDate.getDisplayName(user.getLanguage())%>'); dijit.byId('<%=Event.cal_eventEndDate.getName()%>').focus(); return false; }
        document.frmAdd.submit();
    }
</script>
<form action="<%=url.setAction(SWBResourceURL.Action_ADD)%>" method="post" name="frmAdd">
    <input type="hidden" name="scls" value="<%=Event.sclass%>"/>
    <input type="hidden" name="smode" value="create"/>
    <input type="hidden" name="sref" value="<%=sobj.getURI()%>"/>
    <fieldset>
    <%--=mgr.renderLabel(request, Event.swb_title,mgr.MODE_CREATE)--%>
    <label for="<%=Event.swb_title.getName()%>"><%=Event.swb_title.getDisplayName(user.getLanguage()) == null ? Event.swb_title.getDisplayName() : Event.swb_title.getDisplayName(user.getLanguage())%></label>
    <%=mgr.renderElement(request, Event.swb_title,mgr.MODE_CREATE)%>
    <%=mgr.renderLabel(request, Event.swb_description,mgr.MODE_CREATE)%>
    <%=mgr.renderElement(request, Event.swb_description,mgr.MODE_CREATE)%>
    <%=mgr.renderLabel(request,Event.cal_periodicity,mgr.MODE_CREATE)%>
    <%=mgr.renderElement(request,Event.cal_periodicity,mgr.MODE_CREATE)%>
    <%=mgr.renderLabel(request, Event.cal_eventInitDate,mgr.MODE_CREATE)%>
    <%--=mgr.renderElement(request, Event.cal_eventInitDate,mgr.MODE_CREATE)--%>
    <input id="eventInitDate" name="eventInitDate" dojoType="dijit.form.DateTextBox" style="width: 300px;"/>
    <%=mgr.renderLabel(request, Event.cal_eventEndDate,mgr.MODE_CREATE)%>
    <%--=mgr.renderElement(request, Event.cal_eventEndDate,mgr.MODE_CREATE)--%>
    <input id="eventEndDate" name="eventEndDate" dojoType="dijit.form.DateTextBox"  style="width: 300px;"/>
    <%=mgr.renderLabel(request, Event.cal_urlInternal,mgr.MODE_CREATE)%>
    <input type="checkbox" name="<%=Event.cal_urlInternal.getName()%>">
    <%--=mgr.renderElement(request, Event.cal_urlInternal,mgr.MODE_CREATE)--%>
    <%=mgr.renderLabel(request, Event.cal_urlExternal,mgr.MODE_CREATE)%>
    <%=mgr.renderElement(request, Event.cal_urlExternal,mgr.MODE_CREATE)%>
    <%=mgr.renderLabel(request, Event.cal_newWindow,mgr.MODE_CREATE)%>
    <input type="checkbox" name="<%=Event.cal_newWindow.getName()%>">
    <%--=mgr.renderElement(request, Event.cal_target,mgr.MODE_CREATE)--%>
    <%=mgr.renderLabel(request, Event.cal_image,mgr.MODE_CREATE)%>
    <%=mgr.renderElement(request, Event.cal_image,mgr.MODE_CREATE)%>
    <%=mgr.renderLabel(request, Event.cal_photoPrincipal,mgr.MODE_CREATE)%>
    <%=mgr.renderElement(request, Event.cal_photoPrincipal,mgr.MODE_CREATE)%>
    <%=mgr.renderLabel(request, Event.cal_contentEvent, mgr.MODE_CREATE)%>
    <%=fckEditor%>
    </fieldset>
    <div>
        <button type="button" class="bnt1" onclick="validateData()"><%=paramRequest.getLocaleString("lb_send")%></button>
        <button type="button" class="bnt1" onclick="document.frmCan.submit()"><%=paramRequest.getLocaleString("lb_return")%></button>
    </div>
</form>
<form action="<%=urlBack.setMode("viewEvts")%>" name="frmCan" id="frmCan" method="post"></form>
<% }
}%>