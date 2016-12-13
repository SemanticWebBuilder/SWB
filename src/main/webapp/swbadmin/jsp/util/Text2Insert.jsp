<%@page contentType="text/html;charset=windows-1252"%>
<%@page import="java.io.*"%>
<%@page import="org.semanticwb.*"%>
<%
   //Descomentar esto para utilizar
   if(true)return;
%>
<html>
<head><title>JSP Page</title></head>
<body>


<%
            String path="D:/programming/proys/SWB4/";
            File dir=new File(path);
            findFiles(dir);
%>
Termina..

<%!
        private void findFiles(File dir)
        {
            try{
                if (dir!=null && dir.exists() && dir.isDirectory()) {
                    File[] listado = dir.listFiles();
                    for (int i=0; i < listado.length;i++) {
                        try{
                            if(listado[i].isFile() && listado[i].getName().endsWith(".java")) {
                                 insertText(listado[i]);
                            }
                            if(listado[i].isDirectory()) {
                                 findFiles(listado[i]);
                            }
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    }
                }
            }catch(Exception e){
                e.printStackTrace();
            }
       }


       private void insertText(File file){
            try{
                String sLicence=""+
                "/**  \n"+
                 "* SemanticWebBuilder es una plataforma para el desarrollo de portales y aplicaciones de integraci�n, \n"+
                 "* colaboraci�n y conocimiento, que gracias al uso de tecnolog�a sem�ntica puede generar contextos de \n"+
                 "* informaci�n alrededor de alg�n tema de inter�s o bien integrar informaci�n y aplicaciones de diferentes \n"+
                 "* fuentes, donde a la informaci�n se le asigna un significado, de forma que pueda ser interpretada y \n"+
                 "* procesada por personas y/o sistemas, es una creaci�n original del Fondo de Informaci�n y Documentaci�n \n"+
                 "* para la Industria INFOTEC, cuyo registro se encuentra actualmente en tr�mite. \n"+
                 "* \n"+
                 "* INFOTEC pone a su disposici�n la herramienta SemanticWebBuilder a trav�s de su licenciamiento abierto al p�blico (�open source�), \n"+
                 "* en virtud del cual, usted podr� usarlo en las mismas condiciones con que INFOTEC lo ha dise�ado y puesto a su disposici�n; \n"+
                 "* aprender de �l; distribuirlo a terceros; acceder a su c�digo fuente y modificarlo, y combinarlo o enlazarlo con otro software, \n"+
                 "* todo ello de conformidad con los t�rminos y condiciones de la LICENCIA ABIERTA AL P�BLICO que otorga INFOTEC para la utilizaci�n \n"+
                 "* del SemanticWebBuilder 4.0. \n"+
                 "* \n"+
                 "* INFOTEC no otorga garant�a sobre SemanticWebBuilder, de ninguna especie y naturaleza, ni impl�cita ni expl�cita, \n"+
                 "* siendo usted completamente responsable de la utilizaci�n que le d� y asumiendo la totalidad de los riesgos que puedan derivar \n"+
                 "* de la misma. \n"+
                 "* \n"+
                 "* Si usted tiene cualquier duda o comentario sobre SemanticWebBuilder, INFOTEC pone a su disposici�n la siguiente \n"+
                 "* direcci�n electr�nica: \n"+
                 "*  http://www.semanticwebbuilder.org\n"+
                 "**/ \n \n";

                sLicence=SWBUtils.TEXT.encode(sLicence, "utf-8");
                sLicence+=SWBUtils.IO.readInputStream(new FileInputStream(file));
                InputStream in=SWBUtils.IO.getStreamFromString(sLicence);
                File file2=new File(file.getPath());
                file.delete();
                FileOutputStream out=new FileOutputStream(file2);
                SWBUtils.IO.copyStream(in,out);
                out.flush();
                out.close();
            }catch(Exception e){
                e.printStackTrace();
            }
       }

%>

</body>
</html>
