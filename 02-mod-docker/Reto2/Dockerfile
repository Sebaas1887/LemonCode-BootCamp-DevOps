FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
#venia en 3000, lo cambie a 5000 como dice el readme.
EXPOSE 5000
RUN chown -R node /usr/src/app
USER node
CMD ["npm", "start"]
