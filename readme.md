## Connections

## ADO.NET
```bash
Server=ms-aula-fs.mysql.database.azure.com; Port=3306; Database={your_database}; Uid=adriano@ms-aula-fs; Pwd={your_password}; SslMode=Preferred;
```

## JDBC
```bash
String url ="jdbc:mysql://ms-aula-fs.mysql.database.azure.com:3306/{your_database}?useSSL=true&requireSSL=false"; myDbConn = DriverManager.getConnection(url, "adriano@ms-aula-fs", {your_password});
```

## Node.js
```bash
var conn = mysql.createConnection({host: "ms-aula-fs.mysql.database.azure.com", user: "adriano@ms-aula-fs", password: {your_password}, database: {your_database}, port: 3306, ssl:{ca:fs.readFileSync({ca-cert filename})}});
```

## PHP
```bash
$con=mysqli_init(); mysqli_ssl_set($con, NULL, NULL, {ca-cert filename}, NULL, NULL); mysqli_real_connect($con, "ms-aula-fs.mysql.database.azure.com", "adriano@ms-aula-fs", {your_password}, {your_database}, 3306);
```

## Python
```bash
cnx = mysql.connector.connect(user="adriano@ms-aula-fs", password={your_password}, host="ms-aula-fs.mysql.database.azure.com", port=3306, database={your_database}, ssl_ca={ca-cert filename}, ssl_verify_cert=true)
```

## Ruby
```bash
client = Mysql2::Client.new(username: "adriano@ms-aula-fs", password: {your_password}, database: {your_database}, host: "ms-aula-fs.mysql.database.azure.com", port: 3306, sslca:{ca-cert filename}, sslverify:false, sslcipher:'AES256-SHA')
```

## Web App
```bash
Database={your_database}; Data Source=ms-aula-fs.mysql.database.azure.com; User Id=adriano@ms-aula-fs; Password={your_password}
```