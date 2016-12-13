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
                 "* SemanticWebBuilder es una plataforma para el desarrollo de portales y aplicaciones de integración, \n"+
                 "* colaboración y conocimiento, que gracias al uso de tecnología semántica puede generar contextos de \n"+
                 "* información alrededor de algún tema de interés o bien integrar información y aplicaciones de diferentes \n"+
                 "* fuentes, donde a la información se le asigna un significado, de forma que pueda ser interpretada y \n"+
                 "* procesada por personas y/o sistemas, es una creación original del Fondo de Información y Documentación \n"+
                 "* para la Industria INFOTEC, cuyo registro se encuentra actualmente en trámite. \n"+
                 "* \n"+
                 "* INFOTEC pone a su disposición la herramienta SemanticWebBuilder a través de su licenciamiento abierto al público (‘open source’), \n"+
                 "* en virtud del cual, usted podrá usarlo en las mismas condiciones con que INFOTEC lo ha diseñado y puesto a su disposición; \n"+
                 "* aprender de él; distribuirlo a terceros; acceder a su código fuente y modificarlo, y combinarlo o enlazarlo con otro software, \n"+
                 "* todo ello de conformidad con los términos y condiciones de la LICENCIA ABIERTA AL PÚBLICO que otorga INFOTEC para la utilización \n"+
                 "* del SemanticWebBuilder 4.0. \n"+
                 "* \n"+
                 "* INFOTEC no otorga garantía sobre SemanticWebBuilder, de ninguna especie y naturaleza, ni implícita ni explícita, \n"+
                 "* siendo usted completamente responsable de la utilización que le dé y asumiendo la totalidad de los riesgos que puedan derivar \n"+
                 "* de la misma. \n"+
                 "* \n"+
                 "* Si usted tiene cualquier duda o comentario sobre SemanticWebBuilder, INFOTEC pone a su disposición la siguiente \n"+
                 "* dirección electrónica: \n"+
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
