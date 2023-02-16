import type {Request} from "@cloudflare/workers-types"
export interface Env {
	OKTETO_FQDN_HCFMAILER: string
}

export default {
	async fetch(
		request: Request<unknown>,
		env: Env,
		ctx: ExecutionContext
	): Promise<Response> {
		const url = new URL(request.url);
		url.hostname = env.OKTETO_FQDN_HCFMAILER;
		console.log(`Proxy to:${request.method} ${url.toString()}`)
		request.headers.forEach((value,key) => {
			console.log(`\t${key}:${value}`)
		})
		const data = await fetch(url.toString(),request as RequestInit<RequestInitCfProperties>);
		return data;
	},
};
