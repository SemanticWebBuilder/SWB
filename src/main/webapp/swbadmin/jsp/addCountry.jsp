<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    String scls=request.getParameter("scls");
    String sref=request.getParameter("sref");

    SemanticClass cls=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass(scls);
    SemanticObject ref=SWBPlatform.getSemanticMgr().getOntology().getSemanticObject(sref);

    //System.out.println("cls:"+cls);
    //System.out.println("ref:"+ref);
%>
<form id="<%=scls%>/form" dojoType="dijit.form.Form" class="swbform" action="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/SemObjectEditor.jsp"  onsubmit="submitForm('<%=scls%>/form');return false;" method="post">
    <input type="hidden" name="scls" value="<%=scls%>"/>
    <input type="hidden" name="smode" value="create"/>
    <input type="hidden" name="sref" value="<%=sref%>"/>
	<fieldset>
	    <table>
            <tr>
                <td align="right">
                    <label for="lang"><%=getLocaleString("country",lang)%> &nbsp;</label>
                </td>
                <td>
                    <!--<input name="title" size="30" value="" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="Enter Title." invalidMessage="Title is required." onkeyup="dojo.byId('swb_create_id').value=replaceChars4Id(this.textbox.value);dijit.byId('swb_create_id').validate()" trim="true" style="width:300px;"/>-->
                    <select name="lang" dojoType="dijit.form.FilteringSelect" autoComplete="true" onChange="dojo.byId('swb_create_id').value=this.value;dojo.byId('swb_create_title').value=this.textbox.value;dijit.byId('swb_create_id').validate();">
                        <option value=""></option>
<%
    String counts[] = Locale.getISOCountries();
    for(int x=0;x<counts.length;x++)
    {
        String ct=counts[x].toLowerCase();
        Locale l=new Locale(lang,ct);
        out.println("                        <option value=\""+ct+"\">");
        out.println(toCamelCase(l.getDisplayCountry(new Locale(lang))));
        out.println("</option>");
    }
%>
                    </select>

                </td>
            </tr>
            <tr>
                <td align="right">
                    <label for="title"><%=getLocaleString("title",lang)%> <em>*</em></label>
                </td><td>
                    <input type="text" id="swb_create_title" name="title" dojoType="dijit.form.TextBox" required="true" promptMessage="<%=getLocaleString("enter",lang)%> <%=getLocaleString("title",lang)%>." invalidMessage="<%=getLocaleString("title",lang)%> <%=getLocaleString("invalid",lang)%>." trim="true"/>
	            </td>
            </tr>
            <tr>
                <td align="right">
                    <label><%=getLocaleString("code",lang)%> <em>*</em></label>
                </td><td>
                    <input type="text" id="swb_create_id" name="id" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="<%=getLocaleString("enter",lang)%> <%=getLocaleString("code",lang)%>." isValid="return canCreateSemanticObject('<%=ref.getModel().getName()%>','<%=cls.getClassId()%>',this.textbox.value);" invalidMessage="<%=getLocaleString("code",lang)%> <%=getLocaleString("invalid",lang)%>." trim="true"/>
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