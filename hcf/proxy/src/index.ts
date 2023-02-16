export interface Env {
	OKTETO_FQDN_HCFMAILER: string
}

export default {
	async fetch(
		request: Request,
		env: Env,
		ctx: ExecutionContext
	): Promise<Response> {
		const url = new URL(request.url);
		url.hostname = env.OKTETO_FQDN_HCFMAILER;
		console.log(`Proxy to: ${url.toString()}`)
		const data = await fetch(url.toString(),request.cf as RequestInit<RequestInitCfProperties>);
		return data;
	},
};
