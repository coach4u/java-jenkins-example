name: github actions
on: push 
jobs:
 building:
   runs-on: ubuntu-latest
   steps:
   - name: code checkout
     uses: actions/checkout@v4

   - name: Setup Java 11
     uses: actions/setup-java@v3
     with:
        distribution: 'temurin'
        java-version: '11'
   - name: Build with Maven
     run: mvn clean package -DskipTests

   - name: Upload artifact
     uses: actions/upload-artifact@v3
     with:
       name: application-war
       path: target/*.war

   - name: Configure AWS credentials
     uses: aws-actions/configure-aws-credentials@v2
     with:
       aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
       aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
       aws-region: us-east-1  
   - name: Deploy JAR to S3
     run: aws s3 cp target/*.jar s3://githubaction-bucket0987/ --region us-east-1
     
        
        

     

     
     
  
