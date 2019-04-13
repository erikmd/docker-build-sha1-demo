FROM coqorg/base:latest

ARG BUILD_DATE
ARG VCS_REF
ARG COQ_COMMIT
ARG COQ_VERSION

LABEL maintainer="erik@martin-dorel.org"

LABEL org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.name="The Coq Proof Assistant" \
  org.label-schema.description="Example project description in 300 chars or less" \
  org.label-schema.url="https://coq.inria.fr/" \
  org.label-schema.vcs-ref=${VCS_REF} \
  org.label-schema.vcs-url="https://github.com/coq/coq" \
  org.label-schema.vendor="The Coq Development Team" \
  org.label-schema.version=${COQ_VERSION} \
  org.label-schema.schema-version="1.0"

ENV COQ_VERSION="${COQ_VERSION}"
ENV COQ_EXTRA_OPAM="coq-bignums"

RUN ["/bin/bash", "--login", "-c", "set -x \
  && eval $(opam env --switch=${COMPILER_EDGE} --set-switch) \
  && opam repository add --all-switches --set-default coq-extra-dev https://coq.inria.fr/opam/extra-dev \
  && opam repository add --all-switches --set-default coq-core-dev https://coq.inria.fr/opam/core-dev \
  && opam update -y -u \
  && opam pin add -n -y -k git coq \"git+https://github.com/coq/coq#${COQ_COMMIT}\" \
  && opam install -y -j ${NJOBS} coq ${COQ_EXTRA_OPAM} \
  && opam clean -a -c -s --logs \
  && opam config list && opam list"]

# RUN ["/bin/bash", "--login", "-c", "set -x \
#   && eval $(opam env --switch=${COMPILER} --set-switch) \
#   && opam update -y -u \
#   && opam pin add -n -y -k git coq \"git+https://github.com/coq/coq#${COQ_COMMIT}\" \
#   && opam install -y -j ${NJOBS} coq ${COQ_EXTRA_OPAM} \
#   && opam clean -a -c -s --logs \
#   && opam config list && opam list"]
