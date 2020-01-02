#install.packages("rJava")
#install.packages("DBI")
#install.packages("RJDBC")

#install.packages("ggplot2")


library(DBI)

library(rJava)

library(RJDBC)

library('ggplot2')

drv<-JDBC("oracle.jdbc.driver.OracleDriver","D:\\app\\ParkJeongSu\\product\\11.2.0\\dbhome_2\\jdbc\\lib\\ojdbc6.jar")

conn<-dbConnect(drv, "url","id","pw")

query<- 
  "
SELECT A.SERVERNAME,
       A.EVENTNAME,
       TO_DATE (SUBSTR (A.TIMEKEY, 0, 14), 'YYYYMMDDHH24MISS') TIME,
       A.TIMEKEY,
       A.ELAPSEDTIME,
       A.RESULT
  FROM CT_TRANSACTIONLOG A
 WHERE     1 = 1
       AND A.TIMEKEY BETWEEN '2019123102' AND '2019123104'
       AND A.SERVERNAME LIKE 'TEXsvrTEXsvr%'

"

result <- dbGetQuery(conn,query)

head(result)

all_graph<- ggplot(data=result,aes(x=TIMEKEY,y=ELAPSEDTIME,group=SERVERNAME,color=SERVERNAME)) + geom_line() + theme(axis.text.x = element_blank())

print(all_graph)

facet_graph<- ggplot(data=result,aes(x=TIMEKEY,y=ELAPSEDTIME,group=SERVERNAME,color=SERVERNAME)) + geom_line() + facet_wrap(~ SERVERNAME) + theme(axis.text.x = element_blank())

print(facet_graph)
