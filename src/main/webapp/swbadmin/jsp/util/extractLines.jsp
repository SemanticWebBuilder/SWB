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

Empieza..
<%
            String path="C:/tmp/SWB4/";
            //System.out.println("path:"+path);
            File dir=new File(path);
            findFiles(dir);
%>
Termina..

<%!
        int NLINES=20;
        private void findFiles(File dir)
        {
            try{
                if (dir!=null && dir.exists() && dir.isDirectory()) {
                    File[] listado = dir.listFiles();
                    for (int i=0; i < listado.length;i++) {
                        try{
                            if(listado[i].isFile() && listado[i].getName().endsWith(".java")) {
                                 extractText(listado[i]);
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


       private void extractText(File file){
            try{
                BufferedReader reader= new BufferedReader(new FileReader(file));
                String line= "";
                int cont=0;
                boolean flag=false;
                boolean flag2=false;
                StringBuffer strBfr1= new StringBuffer();
                StringBuffer strBfr2= new StringBuffer();
                while(line!=null) {
                    flag=true;
                    cont++;
                    line= reader.readLine();
                    if(!flag2 && line!=null && !line.equals("null") && line.trim().length()>0) flag2=true;
                    if(cont<=NLINES && flag2 && line!=null && !line.equals("null") && line.trim().length()>0){
                        strBfr1.append(line+"\n");
                    }                    
                }
                if(flag && cont>NLINES){
                    cont=cont-NLINES;
                    int cont1=0;
                    reader= new BufferedReader(new FileReader(file));
                    line= "";
                    while(line!=null) {
                        cont1++;
                        line= reader.readLine();
                        if(cont1>=cont && line!=null && !line.equals("null")){
                           strBfr2.append(line+"\n");
                        }
                    }
                }

                if(flag)
                {
                    String content="";
                    File file2Save=new File("C:/tmp/swb.txt");
                    if(!file2Save.exists()) {
                        System.out.println("Creando archivo:"+file2Save.createNewFile());
                    }
                    FileInputStream fileIStream=new FileInputStream(file2Save);
                    if(fileIStream!=null){
                        content=SWBUtils.IO.readInputStream(fileIStream);
                    }
                    content+="/*-----------------"+file.getName()+"-----------------*\\";
                    content+="\n\n";
                    content+=strBfr1.toString();
                    if(strBfr2.toString()!=null && strBfr2.toString().trim().length()>0){
                        content+="\n.\n.\n.\n";
                        content+=strBfr2.toString();
                    }
                    content+="\n\n\n";
                    InputStream in=SWBUtils.IO.getStreamFromString(content);

                    FileOutputStream out=new FileOutputStream(file2Save);
                    SWBUtils.IO.copyStream(in,out);
                    out.flush();
                    out.close();
                }
                reader.close();
            }catch(Exception e){
                e.printStackTrace();
            }
       }

%>

</body>
</html>
