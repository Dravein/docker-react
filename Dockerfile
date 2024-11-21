FROM node:20.18-alpine as builder

WORKDIR '/app'

# Download and install a dependency
COPY package.json/ ./
RUN npm install
COPY ./ ./
RUN npm run build

FROM nginx
# Az AWS Elastic Bean Stalk ezzel tudja mappelni a portot, a helyett docker run -p 8080:8080 <imageName> (Simán a gépünkre nincs hatással)
EXPOSE 80  
# -Abból az ideiglenes containerből akarunk másolni amit as-el buildernek jelöltünk
# -Meg /app/build mit akarunk lemásolni a konténerből, és hova /user/share/nginx/html (nginx statikus dolgokat amiket kiakar szolgálni ide kell tenni.)
COPY --from=builder /app/build /usr/share/nginx/html
#Nem kell Starter command az nginx-nek mert ez a default comandja az imagenak.