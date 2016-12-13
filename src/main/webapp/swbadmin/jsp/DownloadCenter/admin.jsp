<%@page import="java.text.DecimalFormat"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="java.util.Iterator"%><%@page import="org.semanticwb.portal.api.SWBParamRequest"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
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
<script type="text/javascript">
    dojo.require('dijit.layout.ContentPane');
    dojo.require('dijit.form.Form');
    dojo.require('dijit.form.CheckBox');
    dojo.require('dijit.form.TextBox');
    dojo.require('dijit.form.NumberTextBox');
    dojo.require('dijit.form.Button');
</script>
<%

    SWBResourceURL url = paramRequest.getRenderUrl().setMode(SWBParamRequest.Mode_ADMIN);
    url.setAction("update");
    String resourceId = paramRequest.getResourceBase().getId();
    String jspPath = paramRequest.getResourceBase().getAttribute("jspPath", "/swbadmin/jsp/DownloadCenter/view.jsp");
%>
<div class="swbform">
    <form id="frmIG_<%=resourceId%>" method="post" enctype="multipart/form-data" action="<%=url.toString()%>">
        <table width="100%"  border="0" cellpadding="5" cellspacing="5">
            <tr>
                <td width="200" align="right">
                    <label for="jspPath" class="swbform-label"><%=paramRequest.getLocaleLogString("path")%></label>
                </td>
                <td>
                    <input id="jspPath" name="jspPath" type="text" value="<%=jspPath%>" size="80"/>
                </td>
            </tr>
            <tr>
                <td width="200" align="right">
                    <label for="fileupload" class="swbform-label"><%=paramRequest.getLocaleLogString("addBach")%></label>
                </td>
                <td>
                    <input id="fileupload" name="fileupload" type="file" value="" multiple/>
                </td>
            </tr>
            <tr>
                <td width="200" align="right">
                    <label for="deleteall" class="swbform-label"><%=paramRequest.getLocaleLogString("deleteAll")%></label>
                </td>
                <td>
                    <input id=deleteall" dojotype="dijit.form.CheckBox" name="deleteall" type="checkbox" />
                </td>
            </tr>
            <tr>
                <td width="200" align="right">
                    <label for="igcontainer_<%=resourceId%>" class="swbform-label"><%=paramRequest.getLocaleLogString("list")%></label>
                </td>
                <td>
                    <div id="igcontainer_<%=resourceId%>" style="background-color:#F0F0F0; width:100%; height:432px; overflow:visible">                    
                        <div id="iggrid_<%=resourceId%>" style="width:100%;height:400px;left:2px;top:20px;overflow:scroll; background-color:#EFEFEF">
                            <table id="igtbl_<%=resourceId%>" width="99%" cellspacing="1" bgcolor="#769CCB" align="center">
                                <tr bgcolor="#E1EAF7">
                                    <td align="center" colspan="4"><%=paramRequest.getLocaleLogString("adminFiles")%></td>
                                    <td align="center" colspan="4">
                                        <input type="button" value="<%=paramRequest.getLocaleLogString("add")%>" onclick="addRowToTable('igtbl_<%=resourceId%>');" />&nbsp;
                                        <%--<input type="button" value="Cancelar" onclick="removeRowFromTable('igtbl_<%=resourceId%>');"/></td>--%>
                                    </td>
                                </tr>
                                <tr bgcolor="#769CCB">                                    
                                    <th align="center" scope="col" style="text-align:center;" width="10" height="20" nowrap="nowrap"><%=paramRequest.getLocaleLogString("delete")%></th>
                                    <th align="center" scope="col" style="text-align:center;" width="10" height="20" nowrap="nowrap"><%=paramRequest.getLocaleLogString("edit")%></th>
                                    <th align="center" scope="col" style="text-align:center;" width="30" height="20" nowrap="nowrap"><%=paramRequest.getLocaleLogString("name")%></th>                                    
                                    <th align="center" scope="col" style="text-align:center;" width="10%" height="20" nowrap="nowrap"><%=paramRequest.getLocaleLogString("size")%></th>                                    
                                    <th align="center" scope="col" style="text-align:center;" width="40%" height="20" nowrap="nowrap"><%=paramRequest.getLocaleLogString("title")%></th>
                                    <th align="center" scope="col" style="text-align:center;" width="40%" height="20" nowrap="nowrap"><%=paramRequest.getLocaleLogString("description")%></th>
                                </tr>
                                <tr><td colspan="2" height="10"></td></tr>

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


                                %>

                                <tr>
                                    <td align="center">
                                        <input type="checkbox" value="1" name="remove_<%=resourceId%>_<%=id%>">
                                    </td> 
                                    <td align="center">
                                        <input type="checkbox" value="1" name="edit_<%=resourceId%>_<%=id%>" onclick="editFile('<%=id%>');">
                                    </td>
                                    <td align="center" id="<%=id%>">
                                        <p><%=fileDisplay%></p>
                                    </td>                                    
                                    <td align="center">
                                        <p><%=size%></p>
                                    </td> 
                                    <td align="center">
                                        <input type="text" value="<%=title%>" name="title_<%=id%>" style="width: 95%">
                                    </td> 
                                    <td align="center">
                                        <%--<input type="text" value="<%=desc%>" name="desc_<%=id%>" style="width: 95%">--%>
                                        <textarea type="text" name="desc_<%=id%>" style="width: 95%"><%=desc%></textarea>
                                    </td> 
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </table>
                            </fieldset>                            
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <fieldset>
                        <table width="100%"  border="0" cellpadding="5" cellspacing="0">
                            <tr><td>
                                    <button dojoType="dijit.form.Button" type="submit" name="submitImgGal" value="Submit" onclick="return true;"><%=paramRequest.getLocaleLogString("save")%></button>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </form>
</div>

<script type="text/javascript">
    function editFile(id)
    {
        var eId = document.getElementById(id);
        eId.innerHTML = '<input type="file" id="fileDC_' + id + '" name="fileDC_' + id + '" size="40" />';
    }
    function generateUUID()
    {
        var d = new Date().getTime();
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = (d + Math.random() * 16) % 16 | 0;
            d = Math.floor(d / 16);
            return (c === 'x' ? r : (r & 0x7 | 0x8)).toString(16);
        });
        return uuid;
    }
    
    function replaceAll(find, replace, str) 
    {
      while( str.indexOf(find) > -1)
      {
        str = str.replace(find, replace);
      }
      return str;
    }
    function addRowToTable(tblId) {        
        var tbl = document.getElementById(tblId);        
        var resoruceid='<%=resourceId%>';
        var id = generateUUID();
        var codeadd=document.getElementById('codeadd').innerHTML;        
        codeadd=replaceAll('_id',id,codeadd);
        codeadd=replaceAll('$resourceid',resoruceid,codeadd);
        var row = tbl.insertRow(3);
        row.innerHTML=codeadd;
    }
</script>


<div  style="display: none">
    <table>
    <tr id="codeadd">
        <td align="center">
            <input type="checkbox" value="1" name="remove_$resourceid__id">
        </td> 
        <td align="center">
            <%--<input type="checkbox" value="1" name="edit_$resourceid__id" onclick="editFile('_id');">--%>
        </td>
        <td align="center" id="_id">
            <input type="file" id="fileDC__id" name="fileDC__id" size="40" />
        </td>                                    
        <td align="center">
            <p></p>
        </td> 
        <td align="center">
            <input type="text" value="" name="title__id" style="width: 95%">
        </td> 
        <td align="center">
            <%--<input type="text" value="" name="desc__id" style="width: 95%">--%>
            
            <textarea type="text" name="desc__id" style="width: 95%"></textarea>
        </td> 
    </tr>
    </table>
</div>