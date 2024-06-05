#!/bin/sh

set -e

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "Quitting."
  exit 1
fi

if [ -z "$AWS_CLOUDFRONT_DISTRIBUTION" ]; then
  echo "Quitting."
  exit 1
fi

aws configure --profile invalidate-cloudfront <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# Sync using our dedicated profile and suppress verbose messages.
# All other flags are optional via the `args:` directive.
sh -c "aws cloudfront create-invalidation --distribution-id ${AWS_CLOUDFRONT_DISTRIBUTION} --paths '/*'"

# Clear out credentials after we're done.
# We need to re-run `aws configure` with bogus input instead of
# deleting ~/.aws in case there are other credentials living there.
# https://forums.aws.amazon.com/thread.jspa?threadID=148833
aws configure --profile invalidate-cloudfront <<-EOF > /dev/null 2>&1
null
null
null
text
EOF
