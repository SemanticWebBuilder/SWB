<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.GenericIterator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.model.SWBModel"%>
<%@page import="org.semanticwb.model.Descriptiveable"%>
<%@page import="org.semanticwb.platform.SemanticClass"%>
<%@page import="org.semanticwb.portal.resources.sem.events.Event"%>

<%!
    private final int I_PAGE_SIZE = 20;
    private final int I_INIT_PAGE = 1;
%>

<%
        WebSite site = paramRequest.getWebPage().getWebSite();
        WebPage topic=paramRequest.getWebPage();
        String action = paramRequest.getAction();
        Resource base = paramRequest.getResourceBase();
        SWBResourceURL url = paramRequest.getRenderUrl();
        if (paramRequest.getCallMethod() == paramRequest.Call_STRATEGY) { //Es invocado como estrategía,Poner los 5 eventos más proximos, si es un usuario admin poner liga de administrar
            if (request.getAttribute("events") == null) {
                return;
            }
%>
<table>
    <tr>
        <td><a href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swb/wiki/Eventos">Agenda Municipal</a></td>
    </tr>
    <%
    int cont = 0;
    GenericIterator gitEvents = (GenericIterator) request.getAttribute("events");
    while (gitEvents.hasNext()) {
        Event event = (Event) gitEvents.next();
        if((event.getEventTopic()!=null && event.getEventTopic().equals(topic.getId())) || site.getHomePage().getId().equals(topic.getId()))
        {
        url.setMode(url.Mode_VIEW + "2");
        url.setCallMethod(url.Call_DIRECT);
        url.setParameter("EventUri", event.getURI());
        url.setParameter("closewindow", "1");
    %>
    <tr class="pluginLinks">
        <td nowrap width="30%"><a class="tooltip" style="text-decoration:none;" href="javascript:openWindow()" onclick="openWindow();">><%=event.getTitle()%>
        <span style="left:50px;"><b>Fecha:<%=event.getDate()%><br/>Lugar:<%=event.getPlace()%>&nbsp;</b><br/><%=event.getDescription()%></span></a></td>
    </tr>
    <%
        cont++;
        if (cont >= 5) break;
      }
    }
    %>
</table>
<script type="text/javascript">
    function openWindow(){
        window.open ("<%=url.toString()%>","_new","location=1,resizable=1, status=1,scrollbars=1,width=500,height=500");
    }
</script>
<%
} else { //Es invocado como contenido, poner todos los eventos y si es un usuario de tipo admin poner editar y borrar eventos
    if (action.equals("excel")) {
%>
<table>
    <tr><td>
            <table>
                <tr><td>
                        <table>
                            <tr>
                                <th><%=SWBUtils.TEXT.encode(paramRequest.getLocaleString("title1"), "ISO-8859-1")%></th>
                                <th><%=paramRequest.getLocaleString("description1")%></th>
                                <th><%=paramRequest.getLocaleString("date")%></th>
                            </tr>
                            <%
        if (request.getAttribute("events") == null) {
            return;
        }
        int actualPage = 1;
        String strResTypes[] = getCatSortArray(request, actualPage, request.getParameter("txtFind"));
        String[] pageParams = strResTypes[strResTypes.length - 1].toString().split(":swbp4g1:");
        int iIniPage = Integer.parseInt(pageParams[0]);
        int iFinPage = Integer.parseInt(pageParams[1]);
        int iTotPage = Integer.parseInt(pageParams[2]);
        if (iFinPage == strResTypes.length) {
            iFinPage = iFinPage - 1;
        }
        for (int i = iIniPage; i < strResTypes.length - 1; i++) {
            try {
                String[] strFields = strResTypes[i].toString().split(":swbp4g1:");
                String title = strFields[0];
                String description = strFields[1];
                String date = strFields[2];
                            %>
                            <tr>
                                <td><%=title%></td>
                                <td>
                                    <%if (description != null && !description.equals("null")) {%>
                                    <%=description%>
                                    <%}%>
                                </td>
                                <td><%=date%></td>
                            </tr>
                            <%
            } catch (Exception e) {
            }
        }
                            %>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<%
    } else if (action.equals("addEvent")) {
%>
<form id="http://www.semanticwebbuilder.org/portal/resources/Events#Event/form" class="swbform" action="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swb/wiki/Eventos/_aid/19/_act/add/_mod/add"  onsubmit="submitForm('http://www.semanticwebbuilder.org/portal/resources/Events#Event/form');return false;" method="post">
    <input type="hidden" name="scls" value="http://www.semanticwebbuilder.org/portal/resources/Events#Event"/>
    <input type="hidden" name="smode" value="create"/>
    <input type="hidden" name="sref" value="http://www.wiki.swb#Resource:19"/>
    <fieldset>
        <table>
            <tr><td align="right"><label for="EventTitle">Título <em>*</em></label></td><td><input _id="EventTitle" name="EventTitle" value="" style="width:300px;" /></td></tr>
            <tr><td align="right"><label for="EventDescr">Descripción <em>*</em></label></td><td><textarea name="EventDescr" dojoType_="dijit.Editor" rows="5" cols="40" ></textarea></td></tr>
            <tr><td align="right"><label for="EventDate">Fecha <em>*</em></label></td><td><input _id="EventDate" name="EventDate" value="" style="width:300px;" /></td></tr>
            <tr><td align="right"><label for="EventPlace">Lugar <em>*</em></label></td><td><input name="EventPlace" size="30" value="" /></td></tr>
            <tr><td align="right"><label for="EventTarget">Dirigido a <em>*</em></label></td><td><textarea name="EventTarget" dojoType_="dijit.Editor" rows="5" cols="40" ></textarea></td></tr>
            <tr><td align="right"><label for="EventTarget">Tema <em>*</em></label></td><td>
                    <select name="EventTopic">
                        <%
                        WebPage pageTemas = site.getWebPage("Temas");
                        if (pageTemas != null) {
                            GenericIterator <WebPage> gitWp = pageTemas.listChilds();
                            while (gitWp.hasNext()){
                                WebPage pagechild=gitWp.next();
                        %>
                            <option value="<%=pagechild.getId()%>"><%=pagechild.getTitle()%></option>
                        <%
                            }
                         }
                        %>
                     </select>
                </td>
            </tr>
            <tr><td align="center" colspan="2">
                    <button type="submit">Guardar</button>
                    <button onclick="history.back();">Regresar</button>
            </td></tr>
        </table>
    </fieldset>
</form>
<%
} else {
%>
<link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/css/events.css" rel="stylesheet" type="text/css" />
<table border="0" cellspacing="1" cellpadding="2" width="100%">
    <tr>
        <td align="left" valign="top"  height="25" class="block-title">
            <form action="<%=url.toString()%>">
                <%=paramRequest.getLocaleString("find")%>:<input type="text" name="txtFind"/><button type="submit"><%=paramRequest.getLocaleString("go")%></button>
            </form>
        </td>
        <td nowrap>
            <table width="60%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right">
                        <%url.setAction("addEvent");%>
                        <a href="<%=url.toString()%>"><img src="<%=SWBPlatform.getContextPath()%>/swbadmin/icons/nueva_version.gif" border="0" align="absmiddle" alt="<%=paramRequest.getLocaleString("addEvent")%>" TITLE="<%=paramRequest.getLocaleString("addEvent")%>"></a>
                        <%url.setCallMethod(url.Call_DIRECT);
        url.setAction("excel");
        url.setParameter("txtFind", request.getParameter("txtFind"));
        url.setMode(url.Mode_VIEW);%>
                        <a href="<%=url.toString()%>"><img width="21" height="21" src="<%=SWBPlatform.getContextPath()%>/swbadmin/icons/Excel-32.gif" border="0" align="absmiddle" alt="<%=paramRequest.getLocaleString("exportExcel")%>" TITLE="<%=paramRequest.getLocaleString("exportExcel")%>"></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<table id="K2BTABLEWWPAGECONTENT" class="K2BTableWWPageContent" border="  0" cellpadding="0" cellspacing="0" style="border-width:  0;" >
    <TBODY> <TR> <TD>
            <table id="K2BTABLEWWGRIDCONTENT" class="K2BTableWWGridContent" border="  0" cellpadding="0" cellspacing="0" style="border-width:  0;" >
                <TBODY> <TR> <TD>
                        <table id="GRID1" class="K2BWorkWithGrid" cellpadding="0" cellspacing="1">
                            <tr>
                                <th align="CENTER" width=14px class="K2BWorkWithGridTitle"></th>
                                <th align="CENTER" width=14px class="K2BWorkWithGridTitle"></th>
                                <th align="CENTER" width=14px class="K2BWorkWithGridTitle"></th>
                                <th align="LEFT" width=125px class="K2BWorkWithGridTitle"><%=paramRequest.getLocaleString("title")%></th>
                                <th align="LEFT" nowrap class="K2BWorkWithGridTitle"><%=paramRequest.getLocaleString("description")%></th>
                                <th align="LEFT" nowrap class="K2BWorkWithGridTitle"><%=paramRequest.getLocaleString("date")%></th>
                            </tr>
                            <%
        if (request.getAttribute("events") == null) {
            return;
        }
        //Empieza paginación
        SWBResourceURL urlPag = paramRequest.getRenderUrl();
        int actualPage = 1;
        if (request.getParameter("actualPage") != null) {
            actualPage = Integer.parseInt(request.getParameter("actualPage"));
        }
        String strResTypes[] = getCatSortArray(request, actualPage, request.getParameter("txtFind"));

        String[] pageParams = strResTypes[strResTypes.length - 1].toString().split(":swbp4g1:");
        int iIniPage = Integer.parseInt(pageParams[0]);
        int iFinPage = Integer.parseInt(pageParams[1]);
        int iTotPage = Integer.parseInt(pageParams[2]);
        if (iFinPage == strResTypes.length) {
            iFinPage = iFinPage - 1;
        }

        if (actualPage > 1) {
            int gotop = (actualPage - 1);
            urlPag.setParameter("actualPage", "" + gotop);
            out.println("<a class=\"link\" href=\"" + urlPag.toString() + "\"><<</a>&nbsp;");
        }

        if (iTotPage > 1) {
            for (int i = 1; i <= iTotPage; i++) {
                if (i == actualPage) {
                    out.println(i);
                } else {
                    urlPag.setParameter("actualPage", "" + i);
                    out.println("<a href=\"" + urlPag.toString() + "\">" + i + "</a> \n");
                }
            }
        }

        if (actualPage > 0 && (actualPage + 1 <= iTotPage)) {
            int gotop = (actualPage + 1);
            urlPag.setParameter("actualPage", "" + gotop);
            out.println("<a class=\"link\" href=\"" + urlPag.toString() + "\">>></a>&nbsp;");
        }
        //Termina paginación

        for (int i = iIniPage; i < iFinPage; i++) {
            String[] strFields = strResTypes[i].toString().split(":swbp4g1:");
            String title = strFields[0];
            String description = strFields[1];
            String date = strFields[2];
            String uri = strFields[3];
            url.setCallMethod(url.Call_CONTENT);
            url.setParameter("EventUri", uri);

                            %>
                            <tr class="K2BWorkWithGridOdd"><td valign=top align="CENTER">
                                    <%url.setMode(url.Mode_VIEW + "2");%>
                                <a href="<%=url.toString()%>"><img src="<%=SWBPlatform.getContextPath()%>/swbadmin/icons/gridopen.gif" title="<%=paramRequest.getLocaleString("open")%>" class="K2BWorkWithGridOdd" style=";width: 14"  usemap="''"/></a></td>
                                <td valign=top align="CENTER">
                                    <%url.setMode(url.Mode_EDIT);%>
                                <a href="<%=url.toString()%>"><img src="<%=SWBPlatform.getContextPath()%>/swbadmin/icons/gridupdate.gif" title="<%=paramRequest.getLocaleString("edit")%>" class="K2BWorkWithGridOdd" style=";width: 14"  usemap="''"/></a></td>
                                <td valign=top align="CENTER">
                                    <%url.setMode(url.Mode_VIEW + "2");%>
                                <a href="<%=url.setAction(url.Action_REMOVE).toString()%>"><img src="<%=SWBPlatform.getContextPath()%>/swbadmin/icons/griddelete.gif" title="<%=paramRequest.getLocaleString("remove")%>" class="K2BWorkWithGridOdd" style=";width: 14"  usemap="''"/></a></td>
                                <td valign=top align="RIGHT" style="display:none;" >
                                <td valign=top align="LEFT">
                                <span id="" class="ReadonlyK2BGridAttribute"><%=title%></span></td>
                                <td valign=top align="LEFT">
                                    <span id="span_CUENTACONTABLEDESCRIPCION_0001" class="ReadonlyK2BGridAttribute">
                                        <%if (description != null && !description.equals("null")) {%>
                                        <%=description%>
                                        <%}
                                 url.setAction("add");%>
                                    </span>
                                </td>
                                <td valign=top align="LEFT">
                                <span id="" class="ReadonlyK2BGridAttribute"><%=date%></span></td>
                            </tr>
                            <%
        }
                            %>
                        </table>
                    </TD>
                </TR>
            </table>
        </TD>
    </TR>
</table>
<%
    }
}
%>


<%!    private String[] getCatSortArray(HttpServletRequest request, int actualPage, String txtFind) {
        Vector vRO = new Vector();
        GenericIterator gitEvents = (GenericIterator) request.getAttribute("events");
        while (gitEvents.hasNext()) {
            Event event = (Event) gitEvents.next();
            if (txtFind != null && txtFind.trim().length() > 0) {
                String title = event.getTitle().toLowerCase();
                if (title.startsWith(txtFind.toLowerCase())) {
                    vRO.add(event);
                }
            } else {
                vRO.add(event);
            }
        }

        String[] strArray = new String[vRO.size() + 1];

        Iterator itSObjs = vRO.iterator();
        int cont = 0;
        while (itSObjs.hasNext()) {
            Event event = (Event) itSObjs.next();
            String value = event.getTitle() + ":swbp4g1:" + event.getDescription() + ":swbp4g1:" + event.getDate() + ":swbp4g1:" + event.getURI();
            ;
            strArray[cont] = value;
            cont++;
        }
        strArray[cont] = "zzzzz:zzzz:zzzzz:zzz";

        Arrays.sort(strArray, String.CASE_INSENSITIVE_ORDER);
        String pageparams = getPageRange(strArray.length - 1, actualPage);
        strArray[cont] = pageparams;
        return strArray;
    }

    private String getPageRange(int iSize, int iPageNum) {
        int iTotPage = 0;
        int iPage = I_INIT_PAGE;
        if (iPageNum > 1) {
            iPage = iPageNum;
        }
        if (iSize > I_PAGE_SIZE) {
            iTotPage = iSize / I_PAGE_SIZE;
            int i_ret = iSize % I_PAGE_SIZE;
            if (i_ret > 0) {
                iTotPage = iTotPage + 1;
            }
        } else {
            iTotPage = 1;
        }
        int iIniPage = (I_PAGE_SIZE * iPage) - I_PAGE_SIZE;
        int iFinPage = I_PAGE_SIZE * iPage;
        if (iSize < I_PAGE_SIZE * iPage) {
            iFinPage = iSize;
        }
        return iIniPage + ":swbp4g1:" + iFinPage + ":swbp4g1:" + iTotPage;
    }
%>



