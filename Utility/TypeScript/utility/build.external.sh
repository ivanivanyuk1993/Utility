while read -r LOCAL_DEPENDENCY;
do
  (
    npm install --save-peer "${LOCAL_DEPENDENCY}" \
    && \
    cd "${LOCAL_DEPENDENCY}" \
    && \
    bash build.all.sh
  )
done < local-dependencies.txt
