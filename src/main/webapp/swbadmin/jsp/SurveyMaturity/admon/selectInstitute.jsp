<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.questionnaire.BankInstitution"%>
<%@page import="java.util.Iterator"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<select name="selectInstitution" id="selectInstitution">
                    <%
                        Iterator<BankInstitution> categories=BankInstitution.ClassMgr.listBankInstitutions(paramRequest.getWebPage().getWebSite());
                        while(categories.hasNext())
                        {
                            BankInstitution category=categories.next();

                            %>
                            <option value="<%=category.getURI()%>"><%=category.getNameInstitution()%></option>
                            <%
                        }
                    %>
        </select>