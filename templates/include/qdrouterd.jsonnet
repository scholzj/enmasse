local router = import "router.jsonnet";
local common = import "common.jsonnet";
{
  deployment(addressSpace, image_repo, metrics_image_repo, router_secret, auth_service_ca_secret, address_controller_ca_secret)::
    {
      "apiVersion": "extensions/v1beta1",
      "kind": "Deployment",
      "metadata": {
        "labels": {
          "name": "qdrouterd",
          "app": "enmasse"
        },
        "annotations": {
          "addressSpace": addressSpace,
          "io.enmasse.certSecretName" : "router-internal-cert"
        },
        "name": "qdrouterd"
      },
      "spec": {
        "replicas": 1,
        "template": {
          "metadata": {
            "labels": {
              "capability": "router",
              "name": "qdrouterd",
              "app": "enmasse"
            },
            "annotations": {
              "addressSpace": addressSpace
            }
          },
          "spec": {
            "containers": [ router.container(image_repo, [], "", "router-internal-cert"),
              router.metrics(metrics_image_repo, "32Mi", "router-internal-cert") ],
            "volumes": [
              router.hawkular_volume(),
              common.secret_volume("ssl-certs", router_secret),
              common.secret_volume("authservice-ca", auth_service_ca_secret),
              common.secret_volume("address-controller-ca", address_controller_ca_secret),
              common.secret_volume("router-internal-cert", "router-internal-cert"),
            ]
          }
        }
      }
    }
}
