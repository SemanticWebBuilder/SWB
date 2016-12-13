<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.SWBPortal"%><%@page import="java.text.DecimalFormat"%><%@page import="java.util.Iterator"%><%@page import="javax.activation.MimetypesFileTypeMap"%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%!
    private static final long K = 1024;
    private static final long M = K * K;
    private static final long G = M * K;
    private static final long T = G * K;

    public static String convertToStringRepresentation(final long value)
    {
        final long[] dividers = new long[]
        {
            T, G, M, K, 1
        };
        final String[] units = new String[]
        {
            "TB", "GB", "MB", "KB", "B"
        };
        if (value < 1)
        {
            throw new IllegalArgumentException("Invalid file size: " + value);
        }
        String result = null;
        for (int i = 0; i < dividers.length; i++)
        {
            final long divider = dividers[i];
            if (value >= divider)
            {
                result = format(value, divider, units[i]);
                break;
            }
        }
        return result;
    }

    private static String format(final long value, final long divider, final String unit)
    {
        final double result
                = divider > 1 ? (double) value / (double) divider : (double) value;
        return new DecimalFormat("#,##0.#").format(result) + " " + unit;
    }
%>
<table border="1" id="tablaManuales">
    <tbody>
        <tr>
            <td width="565px">
                <h3>Descripción </h3>
            </td>
            <td>
                <h3>Versión </h3>
            </td>
            <td width="auto">
                <h3>Tamaño</h3>
            </td>
            <td>
                <h3>Descargas</h3>
            </td>
        </tr>
<%
    Iterator<String> it = paramRequest.getResourceBase().getAttributeNames();
    while (it.hasNext())
    {
        String attname = it.next();
        String fileName = paramRequest.getResourceBase().getAttribute(attname);
        if (fileName != null && attname.startsWith("fileDC_"))
        {
            String id = attname.split("_")[1];
            String keyTitle = "title_" + id;
            String title = "";
            if (paramRequest.getResourceBase().getAttribute(keyTitle) != null)
            {
                title = paramRequest.getResourceBase().getAttribute(keyTitle);
            }
            SWBResourceURL wburl = paramRequest.getRenderUrl();
            wburl.setCallMethod(SWBResourceURL.Call_DIRECT);
            wburl.setAction("download");
            String url = wburl.toString() + "/uridoc/" + id;
            title = title.replaceAll("<", "&lt;");
            title = title.replaceAll(">", "&gt;");
            //title = title.replaceAll("'", "%27");
            title = title.replaceAll("\"", "&quot;");
            String keyDesc = "desc_" + id;
            String desc = "";
            if (paramRequest.getResourceBase().getAttribute(keyDesc) != null)
            {
                desc = paramRequest.getResourceBase().getAttribute(keyDesc);
            }
            desc = desc.replaceAll("<", "&lt;");
            desc = desc.replaceAll(">", "&gt;");
            //desc = desc.replaceAll("'", "%27");
            desc = desc.replaceAll("\"", "&quot;");
            String fileDisplay = fileName;
            fileName = SWBPortal.getWorkPath() + paramRequest.getResourceBase().getWorkPath() + "/" + fileName;
            java.io.File file = new java.io.File(fileName);
            String size = "0 bytes";
            if (file.exists() && file.length() > 0)
            {
                size = convertToStringRepresentation(file.length());
            }
            else
            {
                size = file.getAbsolutePath();
            }

            if (title == null || title.isEmpty())
            {
                title = fileDisplay;
            }
            String shits = paramRequest.getResourceBase().getAttribute("hits_" + id, "0");
            if (shits == null || shits.isEmpty())
            {
                shits = "0";
            }
            int hits = Integer.parseInt(shits);            
%>


        <tr>
            <td><%=desc%>
            </td>
            <td>
                <h2><a href="<%=url%>"><img align="absmiddle" src="http://www.semanticwebbuilder.org.mx/css/images/descargar.gif"><%=title%></a></h2>
            </td>
            <td width="auto"><%=size%>

            </td>
            <td align="center"><%=hits%></td>
        </tr>
  

<%        }
    }

%>
  </tbody></table>