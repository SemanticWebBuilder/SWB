<%-- 
    Document   : HTMLContentUploadDialog
    Created on : 07-oct-2015, 12:40:25
    Author     : Hasdai Pacheco
--%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.Map"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.semanticwb.portal.resources.sem.HTMLContent"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%!
    //Taken from http://stackoverflow.com/questions/3758606/how-to-convert-byte-size-into-human-readable-format-in-java
    /**
     * Converts byte size to a human readable string.
     * @param bytes Byte size
     * @param si Nomenclature system to use
     */
    private String humanReadableByteCount(long bytes, boolean si) {
        int unit = si ? 1000 : 1024;
        if (bytes < unit) return bytes + " B";
        int exp = (int) (Math.log(bytes) / Math.log(unit));
        String pre = (si ? "kMGTPE" : "KMGTPE").charAt(exp-1) + (si ? "" : "i");
        return String.format("%.1f %sB", bytes / Math.pow(unit, exp), pre);
    }
    
    /**
     * Gets a regexp for file type validation in javascript function.
     * @param fileType one of image|document|flash|zip|all
     * @return regexp to test file names against for JS validation
     */
    private String getRegexp(String fileType) {
        StringBuilder ret = new StringBuilder();
        ArrayList<String> types = new ArrayList<String>();
        
        if (HTMLContent.TYPE_ALL.equals(fileType) || HTMLContent.TYPE_FLASH.equals(fileType)) {
            types.addAll(Arrays.asList(HTMLContent.swfType));
        }
        if (HTMLContent.TYPE_ALL.equals(fileType) || HTMLContent.TYPE_DOCS.equals(fileType)) {
            types.addAll(Arrays.asList(HTMLContent.docTypes));
        }
        if (HTMLContent.TYPE_ALL.equals(fileType) || HTMLContent.TYPE_IMAGES.equals(fileType)) {
            types.addAll(Arrays.asList(HTMLContent.imgTypes));
        }
        if (HTMLContent.TYPE_ALL.equals(fileType) || HTMLContent.TYPE_ZIP.equals(fileType)) {
            types.addAll(Arrays.asList(HTMLContent.zipTypes));
        }
        
        if (types.isEmpty()) return "";
        
        ret.append("/\\.(");
        for(int i = 0; i < types.size(); i++) {
            ret.append(types.get(i));
            if (i < types.size() - 1) {
                ret.append("|");
            }
        }
        ret.append(")$/i");
        return ret.toString();
    }
%>

<%
    Resource base = paramRequest.getResourceBase();
    int version = (request.getParameter("numversion") != null && !"".equals(request.getParameter("numversion")))
                ? Integer.parseInt(request.getParameter("numversion"))
                : 1;
    String relativeResourcePath = SWBPortal.getWebWorkPath()+base.getWorkPath()+"/"+version+"/images/";
    String fileType = request.getParameter("type");
    String funcNum = request.getParameter("CKEditorFuncNum");
    String action = paramRequest.getAction();
    if (null == fileType) fileType = "";
    Map<String, Long> filesMap = (Map<String, Long>)request.getAttribute(HTMLContent.ATTR_FILES);
    
    SWBResourceURL listFilesUrl = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    listFilesUrl.setMode("selectFileInterface");
    listFilesUrl.setParameter("numversion", String.valueOf(version));
    listFilesUrl.setParameter("type", fileType);
    listFilesUrl.setAction("listFiles");
    
    SWBResourceURL uploadURL = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    uploadURL.setMode(HTMLContent.MOD_UPLOADFILE);
    uploadURL.setAction(HTMLContent.ACT_UPLOADFILE);
    uploadURL.setParameter("numversion", String.valueOf(version));
    uploadURL.setParameter("type", fileType);
    
    if ("listFiles".equals(action)) {
        if (null == filesMap || filesMap.isEmpty() || fileType.isEmpty()) {
            %><div class="alert alert-warning" role="alert"><%= paramRequest.getLocaleString("msgFilesNotFound") %></div><%
        } else {
            %>
            <div id="tableContainer" class="table-responsive">
                <table class="table">
                    <tbody>
                        <%
                        for (String key : filesMap.keySet()) {
                            String fileName = key;
                            long size = filesMap.get(key);
                            boolean hide = !"image".equals(fileType);
                            %>
                            <tr>
                                <td>
                                    <a href="#" class="fileSelector">
                                        <%
                                        if (hide) {
                                            %><span class="fa fa-file fa-2x fa-fw"></span><%
                                        }
                                        %>
                                        <img src="<%= relativeResourcePath + fileName %>" class="imgThumb" <%= hide?"style=\"display:none;\"":"" %>/><%= fileName %>
                                    </a>
                                    <p class="pull-right"><%= humanReadableByteCount(size, true) %></p>
                                </td>
                            </tr>
                            <%
                        }
                        %>
                    </tbody>
                </table>
            </div>
            <%
        }
    } else {
        %>
        <!DOCTYPE html>
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">
                <title>HTMLContent upload image</title>
                <link rel="stylesheet" href="/swbadmin/css/bootstrap/bootstrap.css"></link>
                <link rel="stylesheet" href="/swbadmin/css/fontawesome/font-awesome.css"></link>
                <style type="text/css">
                    .btn-file {position: relative;overflow: hidden;}
                    .btn-file input[type=file] {position: absolute;top: 0;right: 0;min-width: 100%;min-height: 100%;font-size: 100px;text-align: right;filter: alpha(opacity=0);opacity: 0;outline: none;background: white;cursor: inherit;display: block;}
                    .imgThumb {width: 70px;height: 70px;border: 1px solid #ccc;padding:3px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;}
                    a, a:hover {text-decoration: none;}
                </style>
            </head>
            <body>
                <nav class="navbar navbar-default navbar-fixed-top">
                    <form id="uploadForm" class="navbar-form navbar-left" action="<%= uploadURL %>" method="post" enctype="multipart/form-data" target="postiframe">
                        <span id="searchButton" class="btn btn-default btn-file">
                            <i class="fa fa-plus fa-fw"></i><%= paramRequest.getLocaleString("lblAddFile") %> <input name="upload" id="fileChooser" type="file" />
                        </span>
                    </form>
                </nav>
                <div class="container">
                    <div id="container" class="row text-center" style="margin-top:60px;"><span class="fa fa-cog fa-spin"></span></div>
                </div>
                <script src="/swbadmin/js/jquery/jquery.js"></script>
                <script src="/swbadmin/js/bootstrap/bootstrap.js"></script>
                <script>
                    (function() {
                        var theOkAlert = '<div class="alert alert-success" role="alert"><button type="button" class="close" data-dismiss="alert">&times;</button><%= paramRequest.getLocaleString("msgFileUploaded") %></div>';
                        var theErrorAlert = '<div class="alert alert-error" role="alert"><button type="button" class="close" data-dismiss="alert">&times;</button><%= paramRequest.getLocaleString("msgFileUploadError") %></div>';
                        var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');

                        $(document).ready(function() {
                            listFiles();

                            //FileChooser handler
                            $("#fileChooser").on("change", function() {
                                if (isValidFile($(this).val())) {
                                    doSubmit();
                                } else {
                                    alert("<%= paramRequest.getLocaleString("msgFileTypeInvalid") %>");
                                }
                            });
                        });

                        //Checks wheter file extension is valid
                        function isValidFile(fileName) {
                            <%
                            if (fileType.isEmpty()) {
                                %> return false; <%
                            } else {
                                %> return (<%= getRegexp(fileType) %>).test(fileName); <%
                            }
                            %>
                        };

                        //Get file list from work path
                        function listFiles() {
                            $("#container").html("");
                            var jqxhr = $.get('<%= listFilesUrl %>', function(data) {
                               $("#container").html(data);
                               $("#container").removeClass("text-center");

                                //Click handler for image links
                                $('a.fileSelector').click(function() {
                                    var imgSrcVal = $('img', this).attr("src");
                                    if (imgSrcVal) {
                                        //Send back image url to main CKEDITOR dialog
                                        window.opener.CKEDITOR.tools.callFunction(<%= funcNum %>, imgSrcVal);
                                        window.close();
                                    }
                                });
                            });
                            return jqxhr;
                        };

                        //Handle form submit for file upload
                        function doSubmit() {
                            $("#container").append(iframe);

                            var form = $('#uploadForm');
                            form.submit();

                            $("#searchButton").addClass("disabled");

                            $("#postiframe").load(function () {
                                var iframeContents = $(this.contentWindow.document.getElementsByName("uploadStatus")).html();
                                $("#searchButton").removeClass("disabled");

                                if ("SUCCESS" === iframeContents) {
                                    listFiles().done(function() {
                                        $(theOkAlert).insertBefore("#tableContainer"); 
                                    });
                                } else {
                                    listFiles().done(function() {
                                        $(theErrorAlert).insertBefore("#tableContainer"); 
                                    });
                                }
                            });
                        };
                    })();
                </script>
            </body>
        </html>
        <%
    }
%>