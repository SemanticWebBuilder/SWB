<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.model.PFlow"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
PFlow af = (PFlow) SWBPlatform.getSemanticMgr().getOntology().getGenericObject(request.getParameter("suri"));
String resID = af.getWebSite().getId()+"_"+af.getId();

SWBResourceURL data = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("gateway").setAction("getWorkflow");
data.setParameter("suri", request.getParameter("suri"));

SWBResourceURL save = paramRequest.getActionUrl().setAction("updateWorkflow");
save.setParameter("suri", request.getParameter("suri"));
save.setParameter("id", resID);
%>
<div id="addActivityDialog_<%= resID %>" data-dojo-type="dijit.Dialog" title="Agregar actividad">
    <div class="swbform">
        <div id="addActivityTabContainer_<%= resID %>" data-dojo-type="dijit.layout.TabContainer" style="width: 400px; height: 300px;">
            <div data-dojo-type="dijit.layout.ContentPane" title="Propiedades" id="propertiesPane_<%= resID %>">
                <form data-dojo-type="dijit.form.Form" id="addActivity_form<%= resID %>">
                    <input type="hidden" name="uuid" id="uuidActivity_<%= resID %>" />
                    <input type="hidden" name="action" id="activityAct_<%= resID %>" />
                    <fieldset>
                        <table>
                            <tr>
                                <td>
                                    <label>Nombre *:</label>
                                </td>
                                <td>
                                    <input name="name" id="activityName<%= resID %>" data-dojo-type="dijit.form.TextBox"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>Descripción *:</label>
                                </td>
                                <td>
                                    <textarea name="description" id="activityDescription<%= resID %>" data-dojo-type="dijit.form.Textarea"></textarea>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <fieldset><legend>Duración</legend>
                        <table>
                            <tr>
                                <td>
                                    <label>Días:</label>
                                </td>
                                <td>
                                    <input name="days" id="activityDays<%= resID %>" data-dojo-type="dijit.form.TextBox" style="width:3em;"/>
                                </td>
                                <td>
                                    <label>Horas:</label>
                                </td>
                                <td>
                                    <input name="hours" id="activityHours<%= resID %>" data-dojo-type="dijit.form.TextBox" style="width:3em;"/>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </form>
            </div>
            <div data-dojo-type="dijit.layout.ContentPane" title="Usuarios">
                <div id="activityUsers_<%= resID %>"></div>
            </div>
            <div data-dojo-type="dijit.layout.ContentPane" title="Roles">
                <div id="activityRoles_<%= resID %>"></div>
            </div>
        </div>
        <fieldset>
            <button id="addActivityDialogOk_<%= resID %>">Aceptar</button>
            <button id="addActivityDialogCancel_<%= resID %>">Cancelar</button>
        </fieldset>
    </div>
</div>
