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
<style>
    .CSSTableGenerator {
        margin:0px;padding:0px;
        width:100%;
        box-shadow: 10px 10px 5px #888888;
        border:1px solid #000000;

        -moz-border-radius-bottomleft:0px;
        -webkit-border-bottom-left-radius:0px;
        border-bottom-left-radius:0px;

        -moz-border-radius-bottomright:0px;
        -webkit-border-bottom-right-radius:0px;
        border-bottom-right-radius:0px;

        -moz-border-radius-topright:0px;
        -webkit-border-top-right-radius:0px;
        border-top-right-radius:0px;

        -moz-border-radius-topleft:0px;
        -webkit-border-top-left-radius:0px;
        border-top-left-radius:0px;
    }.CSSTableGenerator table{
        border-collapse: collapse;
        border-spacing: 0;
        width:100%;
        height:100%;
        margin:0px;padding:0px;
    }.CSSTableGenerator tr:last-child td:last-child {
        -moz-border-radius-bottomright:0px;
        -webkit-border-bottom-right-radius:0px;
        border-bottom-right-radius:0px;
    }
    .CSSTableGenerator table tr:first-child td:first-child {
        -moz-border-radius-topleft:0px;
        -webkit-border-top-left-radius:0px;
        border-top-left-radius:0px;
    }
    .CSSTableGenerator table tr:first-child td:last-child {
        -moz-border-radius-topright:0px;
        -webkit-border-top-right-radius:0px;
        border-top-right-radius:0px;
    }.CSSTableGenerator tr:last-child td:first-child{
        -moz-border-radius-bottomleft:0px;
        -webkit-border-bottom-left-radius:0px;
        border-bottom-left-radius:0px;
    }.CSSTableGenerator tr:hover td{

    }
    .CSSTableGenerator tr:nth-child(odd){ background-color:#aad4ff; }
    .CSSTableGenerator tr:nth-child(even)    { background-color:#ffffff; }.CSSTableGenerator td{
        vertical-align:middle;


        border:1px solid #000000;
        border-width:0px 1px 1px 0px;
        text-align:left;
        padding:7px;
        font-size:10px;
        font-family:Arial;
        font-weight:normal;
        color:#000000;
    }.CSSTableGenerator tr:last-child td{
        border-width:0px 1px 0px 0px;
    }.CSSTableGenerator tr td:last-child{
        border-width:0px 0px 1px 0px;
    }.CSSTableGenerator tr:last-child td:last-child{
        border-width:0px 0px 0px 0px;
    }
    .CSSTableGenerator tr:first-child td{
        background:-o-linear-gradient(bottom, #005fbf 5%, #003f7f 100%);	background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #005fbf), color-stop(1, #003f7f) );
        background:-moz-linear-gradient( center top, #005fbf 5%, #003f7f 100% );
        filter:progid:DXImageTransform.Microsoft.gradient(startColorstr="#005fbf", endColorstr="#003f7f");	background: -o-linear-gradient(top,#005fbf,003f7f);

        background-color:#005fbf;
        border:0px solid #000000;
        text-align:center;
        border-width:0px 0px 1px 1px;
        font-size:14px;
        font-family:Arial;
        font-weight:bold;
        color:#ffffff;
    }
    .CSSTableGenerator tr:first-child:hover td{
        background:-o-linear-gradient(bottom, #005fbf 5%, #003f7f 100%);	background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #005fbf), color-stop(1, #003f7f) );
        background:-moz-linear-gradient( center top, #005fbf 5%, #003f7f 100% );
        filter:progid:DXImageTransform.Microsoft.gradient(startColorstr="#005fbf", endColorstr="#003f7f");	background: -o-linear-gradient(top,#005fbf,003f7f);

        background-color:#005fbf;
    }
    .CSSTableGenerator tr:first-child td:first-child{
        border-width:0px 0px 1px 0px;
    }
    .CSSTableGenerator tr:first-child td:last-child{
        border-width:0px 0px 1px 1px;
    }
</style>
<%
    boolean showURL = true;
    boolean showdesc = false;
    Iterator<String> it = paramRequest.getResourceBase().getAttributeNames();
    while (it.hasNext())
    {
        String attname = it.next();
        String fileName = paramRequest.getResourceBase().getAttribute(attname);
        if (fileName != null && attname.startsWith("fileDC_"))
        {
            String id = attname.split("_")[1];
            String keyDesc = "desc_" + id;

            if (paramRequest.getResourceBase().getAttribute(keyDesc) != null)
            {
                showdesc = true;
            }
        }
    }
%>
<table class="CSSTableGenerator" width="100%">
    <tr>
        <td>
            Descarga
        </td>
        <%
            if (showdesc)
            {
        %>
        <td>
            Descripción
        </td>        
        <%
            }
        %>
        <%
            if (showURL)
            {
        %>
        <td>
            URL de Descarga
        </td>
        <%
            }
        %>

    </tr>
    <%
        it = paramRequest.getResourceBase().getAttributeNames();
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

    %>
    <tr>
        <td><a href="<%=url%>"><%=title%> (<%=size%>)</a></td>        
        <%
            if (showdesc)
            {
        %>
        <td><%=desc%></td>        
        <%
            }
        %>
        <%
            if (showURL)
            {
        %>
        <td><%=url%><%=url%></td>
        <%
            }
        %>

    </tr>

    <%
            }
        }
    %>

</table>