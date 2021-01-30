import os
import shutil

services = [
    {
        'name': 's3',
        'version': 'v0.0.2'
    },
    {
        'name': 'sfn',
        'version': 'v0.0.2'
    },
    {
        'name': 'elasticache',
        'version': 'v0.0.2'
    },
    {
        'name': 'sns',
        'version': 'v0.0.2'
    },
    {
        'name': 'ecr',
        'version': 'v0.0.2'
    },
    {
        'name': 'dynamodb',
        'version': 'v0.0.2'
    },
    {
        'name': 'apigatewayv2',
        'version': 'v0.0.2'
    }
]

os.environ['HELM_EXPERIMENTAL_OCI'] = '1'

chart_export_path = './charts'
chart_repo = 'public.ecr.aws/aws-controllers-k8s/chart'

shutil.rmtree(chart_export_path)

for service in services:
    chart_ref = '%s:%s-%s' % (chart_repo, service['name'], service['version'])
    os.system('helm chart pull %s' % chart_ref)
    os.system('helm chart export %s --destination %s' % (chart_ref, chart_export_path))

# mkdir -p $CHART_EXPORT_PATH