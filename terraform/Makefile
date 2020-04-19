# Makefile

plan:
	@terraform init -input=false
	@terraform plan -input=false -out=../data/plan.out -detailed-exitcode

apply:
	@terraform apply

destroy:
	@terraform destroy

clean:
	@rm -rf .terraform terraform.tfstate plan.out

stateclean:
	@terraform state rm data.local_file.hosts null_resource.configure_wireguard null_resource.deploy_wireguard null_resource.get_kubeconfig null_resource.localconfig_wireguard null_resource.qrcode-wireguard null_resource.scan_wireguard

.PHONY: clean plan apply destroy
