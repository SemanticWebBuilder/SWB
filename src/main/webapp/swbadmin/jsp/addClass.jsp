<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.hp.hpl.jena.rdf.model.Model"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%!
    String toCamelCase(String txt)
    {
        return (""+txt.charAt(0)).toUpperCase()+txt.substring(1);
    }

    public String getLocaleString(String key, String lang)
    {
        return SWBUtils.TEXT.getLocaleString("locale_swb_admin", key, new Locale(lang));
    }
%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
    String lang=user.getLanguage();
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    //String scls=request.getParameter("scls");
    String sref=request.getParameter("sref");

    //SemanticClass cls=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass(scls);
    SemanticObject ref=SWBPlatform.getSemanticMgr().getOntology().getSemanticObject(sref);
    Model model=ref.getRDFResource().getModel();

    //System.out.println("cls:"+cls);
    //System.out.println("ref:"+ref);
%>
<form id="rdfs:Class/form" dojoType="dijit.form.Form" class="swbform" action="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/SemResourceEditor.jsp"  onsubmit="submitForm('rdfs:Class/form');return false;" method="post">
    <!--<input type="hidden" name="scls" value="< % =scls%>"/>-->
    <input type="hidden" name="act" value="createClass"/>
    <input type="hidden" name="sref" value="<%=sref%>"/>
	<fieldset>
	    <table>
            <tr>
                <td align="right">
                    <label><%=getLocaleString("name",lang)%> <em>*</em></label>
                </td><td>
                    <input type="text" id="swb_create_name" name="id" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="<%=getLocaleString("enter",lang)%> <%=getLocaleString("name",lang)%>." isValid="return canCreateSemanticObject('<%=ref.getModel().getName()%>','rdfs:Class',this.textbox.value);" invalidMessage="<%=getLocaleString("name",lang)%> <%=getLocaleString("invalid",lang)%>." trim="true"/>
	            </td>
            </tr>
            <tr>
                <td align="center" colspan="2">
                    <button dojoType='dijit.form.Button' type="submit"><%=getLocaleString("save",lang)%></button>
                    <button dojoType='dijit.form.Button' onclick="dijit.byId('swbDialog').hide();"><%=getLocaleString("cancel",lang)%></button>
	            </td>
            </tr>
	    </table>
	</fieldset>
</form>