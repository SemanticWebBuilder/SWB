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
            //System.out.println("path:"+path);
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
                                 deleteText(listado[i]);
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

    
       private void deleteText(File file){
            try{
                BufferedReader reader= new BufferedReader(new FileReader(file));
                String line= "";
                int cont=0;
                int tmpCont=0;
                boolean flag=false;
                boolean flag2=false;
                StringBuffer strBfr= new StringBuffer();
                while(line!=null) {
                    cont++;
                    line= reader.readLine();
                    if(line!=null)
                    {
                        if(cont<5 && line.startsWith(" * INFOTEC WebBuilder es una herramienta para el desarrollo de portales de conocimiento")) flag=true;
                        else if(cont>5 && !flag) break;
                        if(flag && !line.equals("null") && line.indexOf("http://www.webbuilder.org.mx")>-1) {
                            tmpCont=cont;
                        }
                        if(tmpCont>0 && !flag2 && !line.equals("null") && line.indexOf("*/")>-1) {
                            tmpCont=cont;
                            flag2=true;
                        }
                        if(flag && flag2 && !line.equals("null") && tmpCont>0 && cont>tmpCont){
                            strBfr.append(line+"\n");
                        }
                     }
                }
                if(flag)
                {
                    InputStream in=SWBUtils.IO.getStreamFromString(strBfr.toString());
                    File file2=new File(file.getPath());
                    file.delete();
                    FileOutputStream out=new FileOutputStream(file2);
                    SWBUtils.IO.copyStream(in,out);
                    in.close();
                    out.close();
                    //System.out.println("**Archivo cambiado:"+file2.getAbsolutePath());
                }
                reader.close();
            }catch(Exception e){
                e.printStackTrace();
            }
       }

%>

</body>
</html>
