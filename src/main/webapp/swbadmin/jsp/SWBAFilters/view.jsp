<%@page import="org.semanticwb.model.User"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.model.AdminFilter"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.model.GenericObject"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.UserRepository"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
User user = SWBContext.getAdminUser();
String lang = "es";
if (null != user && null != user.getLanguage()) lang = user.getLanguage();

if (!SWBContext.getAdminWebSite().equals(paramRequest.getWebPage().getWebSite())) {
    %>Recurso de administración<%
} else if (null != user) {
    UserRepository map = SWBContext.getAdminRepository();

    String removed = (String) request.getSession().getAttribute("removedId");
    if (null != removed && !removed.isEmpty()) {
        request.getSession().removeAttribute("removedId");
        %>
        <script>
            closeTab('<%= removed %>');
            showStatus('<%= paramRequest.getLocaleString("msgDeleted") %>');
        </script>
        <%
    }
    %>
    <style type="text/css">
        table.swbafilters {
            width:100%;
        }
        
        table.swbafilters tbody tr:nth-child(even) {
           background-color: #E1EBFB;
        }
    </style>
    <div class="swbform">
        <fieldset>
            <table class="swbafilters">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th><%= paramRequest.getLocaleString("lblFilter") %></th>
                        <th><%= paramRequest.getLocaleString("lblDescription") %></th>
                        <th></th>
                    </tr>
                </thead>
                <%
                Iterator<AdminFilter> filters = AdminFilter.ClassMgr.listAdminFilters(map);
                if (filters.hasNext()) {
                    SWBResourceURL remove = paramRequest.getActionUrl().setAction(SWBResourceURL.Action_REMOVE);
                    %>
                    <tbody>
                        <%
                        while(filters.hasNext()) {
                            AdminFilter filter = filters.next();
                            remove.setParameter("id", filter.getId());
                            %>
                            <tr>
                                <td style="width:60px;"><%= filter.getId() %></td>
                                <td><%= filter.getDisplayTitle(lang)%></td>
                                <td><%= filter.getDisplayDescription(lang) != null ? filter.getDisplayDescription(lang) : ""%></td>
                                <td style="width:60px;">
                                    <a href="#" title="<%= paramRequest.getLocaleString("lblEdit") %>"onclick="addNewTab('<%= filter.getURI() %>','<%= SWBPlatform.getContextPath() %>/swbadmin/jsp/objectTab.jsp','<%= filter.getDisplayTitle(user.getLanguage()) %>'); return false;"><img src="<%= SWBPlatform.getContextPath() + "/swbadmin/icons/editar_1.gif" %>" /></a>
                                    <a href="#" title="<%= paramRequest.getLocaleString("lblRemove") %>" onclick="if (confirm('<%= paramRequest.getLocaleString("msgDelete") %>')) {submitUrl('<%= remove %>',this); return false; } else { return false; };" ><img src="<%= SWBPlatform.getContextPath() + "/swbadmin/images/delete.gif" %>" /></a>
                                </td>
                            </tr>
                            <%
                        }
                        %>
                    </tbody>
                    <%
                }
                %>
            </table>
        </fieldset>
        <fieldset>
            <%
            String urlAddNew = SWBPlatform.getContextPath() + "/swbadmin/jsp/SemObjectEditor.jsp";
            urlAddNew += "?scls=" + AdminFilter.sclass.getEncodedURI() + "&sref=" + map.getEncodedURI() + "&reloadTab=true";
            %>
            <button dojoType="dijit.form.Button" onclick="showDialog('<%= urlAddNew %>','<%= AdminFilter.sclass.getDisplayName(lang) %>'); reloadTab('<%= paramRequest.getResourceBase().getURI() %>'); return false;"><%= paramRequest.getLocaleString("lblAdd") %></button>
        </fieldset>
    </div>
    <%
}
%>