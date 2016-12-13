<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    User user=paramRequest.getUser();
    WebPage wpage=paramRequest.getWebPage();
    String mode=paramRequest.getArgument("mode", "");

        if(mode!=null && mode.equals("content"))
            {

%>
<script type="text/javascript">
    dojo.require("dijit.form.ValidationTextBox");
    init('<%=SWBPortal.getContextPath()%>');
</script>


<div class="soria">
    <h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proporciona la siguiente información para la Nueva comunidad</h4>
    <!-- <fieldset><legend></legend> -->
        <table border="0">
            <tr><td width="20">&nbsp;</td><td>
<%
    SWBFormMgr mgr=new SWBFormMgr(MicroSite.sclass, wpage.getSemanticObject(), null);
    mgr.setType(mgr.TYPE_DOJO);
    mgr.setAction(paramRequest.getActionUrl().toString());
    mgr.addProperty(Descriptiveable.swb_description);
    mgr.addProperty(WebPage.swb_tags);
    //mgr.addProperty(MicroSite.swbcomm_type);
    mgr.addProperty(MicroSite.swbcomm_private);
    mgr.addProperty(MicroSite.swbcomm_moderate);
    mgr.addProperty(MicroSiteType.swbcomm_hasMicroSiteUtil);
    mgr.addButton(SWBFormButton.newSaveButton().setAttribute("class","adminTool").setAttribute("style", "border:none;"));
    mgr.addButton(SWBFormButton.newCancelButton().setAttribute("onclick", "window.location='"+paramRequest.getRenderUrl().setWindowState(SWBResourceURL.WinState_NORMAL)+"';").setAttribute("class","adminTool").setAttribute("style", "border:none;"));
    mgr.addHiddenParameter("act", "add");
    out.println(mgr.renderForm(request));
%>
                </td></tr>
        </table>
    <!-- </fieldset> -->
</div>
    

    <%
    }
    %>
    