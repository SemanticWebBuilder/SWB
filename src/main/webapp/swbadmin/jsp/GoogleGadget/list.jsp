<%@page import="org.semanticwb.portal.resources.googlegadgets.GoogleGadget"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.Locale"%>
<%@page import="org.semanticwb.portal.resources.googlegadgets.Gadget"%>
<%@page import="java.net.URL"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="org.semanticwb.portal.resources.googlegadgets.GadgetLoader"%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            Locale _default = new Locale("es");
            if (paramRequest.getUser().getLanguage() != null)
            {
                _default = new Locale(paramRequest.getUser().getLanguage());
            }

            GadgetLoader loader = (GadgetLoader) request.getAttribute("loader");
            loader.next();
            loader.next();
            int start = 0;
            if (request.getParameter("start") != null)
            {
                try
                {
                    start = Integer.parseInt(request.getParameter("start"));
                }
                catch (Exception e)
                {
                    GoogleGadget.log.debug(e);

                }
            }
%>
<table width="50%">
    <%
                int index = 0;

                for (URL url : loader.getList())
                {
                    index++;
                    if (index > start && index < (start + 7))
                        try
                        {
                            Gadget g = new Gadget(url);
                            String image = g.getSrcImage(_default);
                            String title = g.getTitle(_default);
                            SWBResourceURL urlToAdd = paramRequest.getRenderUrl();
                            //urlToAdd.setWindowState(SWBResourceURL.WinState_NORMAL);
                            urlToAdd.setMode("addGadget");
                            urlToAdd.setParameter("url", url.toString());
    %>
    <tr>
        <td><img alt="<%=title%>"  width="120" height="60" src="<%=image%>"></td><td> <a href="<%=urlToAdd%>">Agregar <%=title%></a></td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <%
                        }
                        catch (Exception e)
                        {
                            GoogleGadget.log.error(e);
                        }
                }
    %>
</table>
<%
            SWBResourceURL url_next = paramRequest.getRenderUrl();

            int newStart = start + 7;
            url_next.setParameter("start", "" + newStart);


            int anterior = start - 7;

            SWBResourceURL url_back = paramRequest.getRenderUrl();

            if (anterior < 0)
            {
                anterior = 0;
            }
            url_back.setParameter("start", "" + anterior);


%>

<br><br>

<table width="50%">
    <%
                if (start != 0)
                {
    %>
    <tr><td><a href="<%=url_back%>"><<</a></td>
    <%
                }
                
    %>



    <td><a href="<%=url_next%>">>></a></td>
    <%

    %>
</tr>
    </table>
