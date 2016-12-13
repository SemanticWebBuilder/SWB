<%@page contentType="application/octet-stream" pageEncoding="UTF-8"%><%@
page import="java.io.*,java.text.*" %><%@
page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%><%@
page import="org.semanticwb.model.Resource" %><%@page import="org.semanticwb.portal.SWBFormMgr"%><%
    ServletOutputStream sout = response.getOutputStream();
    String uri = request.getParameter("uri");
    DocumentElement doc = (DocumentElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment;filename=" + doc.getDocumentURL());
    if(doc != null) {
        //ServletOutputStream sout = response.getOutputStream();
        String path = SWBPortal.getWorkPath()+doc.getWorkPath()+"/"+doc.getDocumentURL();
        BufferedInputStream in = new BufferedInputStream(new FileInputStream(path));
        byte[] data = new byte[1024];
        while ( in.read(data) != -1) {
            sout.write(data);
        }
        in.close();
        sout.close();
    }
%>